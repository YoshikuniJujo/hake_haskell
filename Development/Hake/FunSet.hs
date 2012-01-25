module Development.Hake.FunSet (

  file
, task
, rule
, ruleV
, ruleSS

) where

import Data.List                    (isSuffixOf)
import Data.Function.Tools          (const2)
import Development.Hake.Types       (Rule, getSrcs)
import Development.Hake.Tools       (changeSuffix, systemE, orDie)
import Control.Monad.Trans          (MonadIO)

systemExit :: MonadIO m => String -> m ()
systemExit = flip orDie show . systemE

file :: [String] -> [String] -> (String -> [String] -> [String]) -> Rule
file trgts srcs cmd
  = ( \f -> or $ map (==f) trgts, const srcs,
      \t s -> sequence_ $ map systemExit $ cmd t s )

task :: String -> [String] -> Rule
task trgts cmd = ( (==trgts), const [], const2 $ sequence_ $ map systemExit cmd )

rule :: String -> String -> (String -> [String] -> [String]) -> Rule
rule trgt src cmd
  = ( isSuffixOf trgt, \dst -> [changeSuffix trgt src dst ],
      \t s -> sequence_ $ map systemExit $ cmd t s )

ruleV ::
  String -> [String] -> [String] -> (String -> [String] -> [String]) -> Rule
ruleV trgt srcs cmmns cmd
  = ( isSuffixOf trgt, \dst -> map (flip (changeSuffix trgt) dst) srcs ++ cmmns,
      \t s -> sequence_ $ map systemExit $ cmd t s )

ruleSS ::
  String -> String -> (String -> [String] -> [ (String, [String]) ]) -> Rule
ruleSS trgt src cmds
  = ( isSuffixOf trgt, \dst -> [ changeSuffix trgt src dst ],
      \t s -> do (srcSrc:_) <- getSrcs $ head s
	         sequence_ $ map systemExit $ snd $ head $
		   filter ( flip isSuffixOf srcSrc . fst ) $ cmds t s )
