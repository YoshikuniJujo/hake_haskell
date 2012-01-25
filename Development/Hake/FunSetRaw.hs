module Development.Hake.FunSetRaw (

  file
, task
, rule
, ruleV
, ruleSS

) where

import Data.List                    (isSuffixOf)
import Data.Function.Tools          (const2)
import Development.Hake.Types       (Rule, getSrcs)
import Development.Hake.Tools       (changeSuffix, rawSystemE, orDie)
import Control.Monad.Trans          (MonadIO)

rawSystemExit :: MonadIO m => [ String ] -> m ()
rawSystemExit = flip orDie show . rawSystemE

file :: [String] -> [String] -> (String -> [String] -> [[String]]) -> Rule
file trgts srcs cmd
  = ( \f -> or $ map (==f) trgts, const srcs,
      \t s -> sequence_ $ map rawSystemExit $ cmd t s )

task :: String -> [[String]] -> Rule
task trgts cmd
  = ( (==trgts), const [], const2 $ sequence_ $ map rawSystemExit cmd )

rule :: String -> String -> (String -> [String] -> [[String]]) -> Rule
rule trgt src cmd
  = ( isSuffixOf trgt, \dst -> [changeSuffix trgt src dst ],
      \t s -> sequence_ $ map rawSystemExit $ cmd t s )

ruleV ::
  String -> [String] -> [String] -> (String -> [String] -> [[String]]) -> Rule
ruleV trgt srcs cmmns cmd
  = ( isSuffixOf trgt, \dst -> map (flip (changeSuffix trgt) dst) srcs ++ cmmns,
      \t s -> sequence_ $ map rawSystemExit $ cmd t s )

ruleSS ::
  String -> String -> (String -> [String] -> [ (String, [[String]]) ]) -> Rule
ruleSS trgt src cmds
  = ( isSuffixOf trgt, \dst -> [ changeSuffix trgt src dst ],
      \t s -> do (srcSrc:_) <- getSrcs $ head s
	         sequence_ $ map rawSystemExit $ snd $ head $
		   filter ( flip isSuffixOf srcSrc . fst ) $ cmds t s )
