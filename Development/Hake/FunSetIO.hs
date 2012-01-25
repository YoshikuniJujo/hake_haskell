module Development.Hake.FunSetIO (

  file
, task
, rule
, ruleV
, ruleSS

, orDie

) where

import System.Exit                  (ExitCode)
import Data.List                    (isSuffixOf)
import Data.Function.Tools          (const2)
import Control.Monad.Reader         (lift)
import Development.Hake.Types       (Rule, getSrcs)
import Development.Hake.Tools       (orDie, changeSuffix)

file :: [String] -> [String] -> (String -> [String] -> IO ExitCode) -> Rule
file trgts srcs cmd
  = ( \f -> or $ map (==f) trgts, const srcs,
      \t s -> lift $ (flip orDie show) $ cmd t s )

task :: String -> IO ExitCode -> Rule
task trgts cmd = ( (==trgts), const [], const2 $ lift cmd `orDie` show)

rule :: String -> String -> (String -> [String] -> IO ExitCode) -> Rule
rule trgt src cmd
  = ( isSuffixOf trgt, \dst -> [changeSuffix trgt src dst ],
      (.) (flip orDie show) . (.) lift . cmd )

ruleV ::
  String -> [String] -> [String] -> (String -> [String] -> IO ExitCode) -> Rule
ruleV trgt srcs cmmns cmd
  = ( isSuffixOf trgt, \dst -> map (flip (changeSuffix trgt) dst) srcs ++ cmmns,
      (.) (flip orDie show) . (.) lift . cmd )

ruleSS ::
  String -> String -> (String -> [String] -> [ (String, IO ExitCode) ]) -> Rule
ruleSS trgt src cmds
  = ( isSuffixOf trgt, \dst -> [ changeSuffix trgt src dst ],
      \t s -> do (srcSrc:_) <- getSrcs $ head s
	         lift $ flip orDie show $ snd $ head $
		   filter ( flip isSuffixOf srcSrc . fst ) $ cmds t s)
