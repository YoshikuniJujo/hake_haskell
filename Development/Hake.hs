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

module Development.Hake (

  Rule
, hake
, hakeT
, hakefileIs

, base
, dflt
, deps
, mkfl

, addDeps
, delRules
, setCmd

, systemE
, rawSystemE

, isSuffixOf
, changeSuffix
, getVals
, getNewers

, ExitCode(ExitSuccess, ExitFailure)
, const2

) where

import System.Environment           (getArgs)
import System.Exit                  (ExitCode(ExitSuccess, ExitFailure))
import System.Directory             (doesFileExist)
import System.Directory.Tools       (maybeGetModificationTime)
import System.IO.Unsafe             (unsafeInterleaveIO)
import Control.Monad.Trans          (lift)
import Control.Monad.Reader         (ReaderT(runReaderT), asks)
import Control.Monad.Tools          (whenM)
import Control.Applicative          ((<$>))
import Data.List                    (isSuffixOf, isPrefixOf)
import Data.List.Tools              (dropUntil, isIncludedElem)
import Data.Maybe                   (listToMaybe, catMaybes)
import Data.Bool.Tools              ((&&&), (|||))
import Data.Function.Tools          (const2)
import Development.Hake.Core        (traceRule, applyRule)
import Development.Hake.RunHake     (runHake)
import Development.Hake.Tools       (orDie, changeSuffix, systemE, rawSystemE)
import Development.Hake.Types       (Rule, RuleInner, ruleToRuleInner,
				     Targets, Sources, Commands,
				     MadeFromList, ruleRetToMadeFromList,
				     getUpdateStatus)
import Development.Hake.Variables   (hakefileUpdateOption, defaultTrgtStr)

-- |The 'hake' function take rules as argument and get target from command line
--  and make target.
hake :: [ Rule ] -> IO ()
hake rl = do args <- filter (notElem '=') <$> getArgs
             let ud    = elem hakefileUpdateOption args
	         trgts = filter (/=hakefileUpdateOption) args
	     mapM_ (hakeTarget ud (map ruleToRuleInner rl)) trgts

hakeT :: [ Rule ] -> FilePath -> IO ()
hakeT = hakeTarget True . map ruleToRuleInner

hakefileIs :: FilePath -> [ FilePath ] -> IO ExitCode
hakefileIs src others = getArgs >>= runHake src src others

hakeTarget :: Bool -> [ RuleInner ] -> FilePath -> IO ()
hakeTarget ud rls fn = do
  rrls <- traceRule unsafeInterleaveIO doesFileExist fn rls
  case rrls of
       []  -> error $ "No usable rules for make target '" ++ fn ++ "'"
       r:_ -> flip runReaderT (ud, ruleRetToMadeFromList r) $ mapM_ applyRule
                                                            $ reverse r

addDeps :: [ Rule ] -> [ (FilePath, [FilePath]) ] -> [ Rule ]
addDeps rls adrls = concatMap ad adrls ++ map dels rls
  where
  ad :: (FilePath, [FilePath]) -> [ Rule ]
  ad (t, ss) = [ ((==t), const $ sgen t ++ ss, c) |
                 (testT, sgen, c) <- rls, testT t ]
  dels :: Rule -> Rule
  dels r = foldr del r $ map fst adrls
  del :: FilePath -> Rule -> Rule
  del t r@(pt, _, _)
    | pt t      = modifyFirstOfThree (&&& (/=t)) r
    | otherwise = r
  modifyFirstOfThree f (x, y, z) = (f x, y, z)

delRules :: [ Rule ] -> [ (FilePath, [FilePath]) ] -> [ Rule ]
delRules rls delrls = map dels rls
  where
  dels :: Rule -> Rule
  dels r = foldr del r delrls
  del :: (FilePath, [FilePath]) -> Rule -> Rule
  del (t, ss) r@(pt, mkSs, _)
    | pt t && isIncludedElem ss (mkSs t) = modifyFirstOfThree (&&& (/=t)) r
    | otherwise                          = r
  modifyFirstOfThree f (x, y, z) = (f x, y, z)

setCmd ::
  Rule -> ( String -> [ String ] -> MadeFromList -> IO ExitCode ) -> Rule
setCmd (trgts, srcs, _) cmdsGen = (trgts, srcs, cmd)
  where cmd :: Commands
        cmd t s = do mfl <- asks snd
	             lift $ cmdsGen t s mfl `orDie` show

getVals :: String -> [String] -> [String]
getVals var args = maybe [] words $
  dropUntil (=='=') <$> (listToMaybe $ filter (isPrefixOf $ var ++ "=") args)

getNewers :: FilePath -> [ FilePath ] -> IO [ FilePath ]
getNewers fb fs = catMaybes <$> mapM getNewer fs
  where
  getNewer :: FilePath -> IO (Maybe FilePath)
  getNewer f = do
    tb <- maybeGetModificationTime fb
    t  <- maybeGetModificationTime f
    if (tb < t) then return $ Just f else return Nothing

base ::
  Targets -> Sources
          -> ( String -> [ String ] -> MadeFromList -> Bool -> IO ExitCode )
          -> Rule
base trgts srcs cmdsGen = (trgts, srcs, cmd)
  where cmd :: Commands
        cmd t s = do mfl <- asks snd
	             us  <- asks fst
		     lift $ cmdsGen t s mfl us `orDie` show

dflt :: [ String ] -> Rule
dflt trgts = ( (==defaultTrgtStr), const trgts, const2 $ return () )

deps :: [ String ] -> [ String ] -> Rule
deps trgts srcs
  = ( \f -> or $ map (==f) trgts, const srcs, const2 $ return ())

mkfl :: String -> [ String ] -> Rule
mkfl trgt cont
  = ( (==trgt), const [], \t -> const $ do
        whenM (getUpdateStatus ||| lift (not <$> doesFileExist trgt)) $ do
	  lift $ putStrLn $ "make file `" ++ trgt ++ "' (hake)"
	  lift $ writeFile t $ unlines cont )
