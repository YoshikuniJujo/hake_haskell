module Development.Hake.OldFunSet (

  file
, task
, rule
, ruleSS

) where

import Data.List                    (isSuffixOf)
import Data.Function.Tools          (const2)
import Development.Hake.Types       (Rule, getSrcs)
import Development.Hake.Tools       (changeSuffix, systemE)


file :: ( [String], [String], [String] ) -> Rule
file ( trgts, srcs, cmd )
  = ( \f -> or $ map (==f) trgts, const srcs,
      const2 $ sequence_ $ map systemE cmd )

task :: ( String, [String] ) -> Rule
task ( trgts, cmd )
  = ( (==trgts), const [], const2 $ sequence_ $ map systemE cmd )

rule :: ( String, String, String -> String -> [String] ) -> Rule
rule ( trgt, src, cmd )
  = ( isSuffixOf trgt, \dst -> [changeSuffix trgt src dst ],
      \t (s:_) -> sequence_ $ map systemE $ cmd t s )

ruleSS :: ( String, String, String -> String -> [ (String, [String]) ] ) -> Rule
ruleSS ( trgt, src, cmds )
  = ( isSuffixOf trgt, \dst -> [ changeSuffix trgt src dst ],
      \t (s:_) -> do [ srcSrc ] <- getSrcs s
	             sequence_ $ map systemE $
		       snd $ head $
		       filter ( flip isSuffixOf srcSrc . fst ) $ cmds t s )
