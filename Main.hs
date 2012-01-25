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

module Main where

import System.Environment           (getArgs)
import System.Console.GetOpt        (getOpt,
                                     ArgOrder(Permute), OptDescr(Option),
				     ArgDescr(ReqArg, NoArg))
import System.Exit                  (exitWith, ExitCode(ExitFailure))
import Data.Version                 (showVersion)
import Data.Maybe                   (mapMaybe)
import Control.Applicative          ((<$>))
import Paths_hake                   (version)
import Development.Hake.RunHake     (runHake)

main :: IO ()
main = do
  (ver, hFile, args) <- processArgs
  if ver then putStrLn ("hake " ++ showVersion version)
         else runHake hFile hFile [] args >>= exitWith

processArgs :: IO ( Bool, String, [ String ] )
processArgs = do
  (opts, args, errMsgs) <- getOpt Permute optionList <$> getArgs
  let ver   = elem OptVersion opts
      hFile = head $ mapMaybe getHakefile $ opts ++ [ OptHakefile "Hakefile" ]
  case errMsgs of
       [] -> return ()
       _  -> mapM_ putStr errMsgs >> exitWith (ExitFailure 1)
  return ( ver, hFile, args )

data Opt = OptVersion | OptHakefile FilePath deriving Eq
getHakefile :: Opt -> Maybe FilePath
getHakefile (OptHakefile hf) = Just hf
getHakefile _                = Nothing

optionList :: [ OptDescr Opt ]
optionList = [
 Option "f" [] (ReqArg OptHakefile "file as Hakefile") "set Hakefile",
 Option "" [ "version" ] (NoArg OptVersion) "show version"
 ]
