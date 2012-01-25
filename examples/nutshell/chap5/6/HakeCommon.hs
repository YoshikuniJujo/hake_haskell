module HakeCommon (
  commonRules
) where

import Development.Hake
import Development.Hake.FunSetRaw

commonRules :: [ String ] -> [ Rule ]
commonRules cflags = [

 base (isSuffixOf ".o") (\t -> [ "../src/" ++ changeSuffix ".o" ".c" t ]) $
   \_ (s:_) _ _ -> rawSystemE $ [ "cc" ] ++ cflags ++ [ "-c", s ]

 ]
