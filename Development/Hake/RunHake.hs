{- hake: make tool. ruby : rake = haskell : hake
Copyright (C) 2008-2008 Yoshikuni Jujo <PAF01143@nifty.ne.jp>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
-}

module Development.Hake.RunHake (

  runHake

) where

import System.Exit                (ExitCode(ExitSuccess), exitWith)
import System.Directory           (createDirectory, doesDirectoryExist,
                                   doesFileExist)
import System.Directory.Tools     (doesNotExistOrOldThan)
import System.FilePath            (takeFileName)
import System.Process             (runProcess, waitForProcess)
import Control.Monad              (when)
import Control.Monad.Tools        (unlessM, filterM)
import Data.Function.Tools        (applyWhen, apply2way)
import YJTools.Tribial            (ghcMake, updateFile)
import Text.RegexPR               (gsubRegexPR, ggetbrsRegexPR)
import Development.Hake.Variables (defaultTrgtStr, hakefileUpdateOption,
                                   hakeDir, commentPair, srcSuffix, exeEscPairs)

runHake :: FilePath -> FilePath -> [ FilePath ] -> [ String ] -> IO ExitCode
runHake src exe othrs args = do
  let bin     = foldr (uncurry gsubRegexPR) exe exeEscPairs
      binPath = hakeDir ++ bin
      binSrc  = hakeDir ++ bin ++ srcSuffix
  mapM_ errorNotExist $ src : othrs
  unlessM (doesDirectoryExist hakeDir) $ createDirectory hakeDir
  othrsUD
    <- fmap or $ flip mapM othrs
               $ apply2way (updateFile commentPair) id $
			                            (hakeDir ++) . takeFileName
  hakefileUD  <- updateFile commentPair src binSrc
  modUD <-
    if null othrs
       then do mods <- getModules src
               fmap or $ flip mapM mods
                       $ apply2way (updateFile commentPair) id $
	                                                    (hakeDir ++)
       else return False
  notUpdated  <- doesNotExistOrOldThan binPath binSrc
  when (othrsUD || hakefileUD || notUpdated || modUD) $ do
    ec <- ghcMake bin hakeDir
    when (ec /= ExitSuccess) $ exitWith ec
  let args_  = applyWhen (othrsUD || hakefileUD) (hakefileUpdateOption:) $
                 applyWhen (null $ filter (notElem '=') args) (defaultTrgtStr:) args
  runProcess binPath args_ Nothing Nothing Nothing Nothing Nothing
    >>= waitForProcess

errorNotExist :: FilePath -> IO ()
errorNotExist fp = unlessM (doesFileExist fp) $
                     error $ "runHake: " ++ fp ++ " does not exist"

getModules :: FilePath -> IO [ FilePath ]
getModules hf = do
  cont <- readFile hf
  let mods_ = map (!!1) $ ggetbrsRegexPR "^import\\s+([^\n\\([:blank:]]+)" cont
  mods <- filterM doesFileExist $ map (++".hs") mods_
  return mods
