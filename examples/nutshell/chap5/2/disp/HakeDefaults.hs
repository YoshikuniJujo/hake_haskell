module HakeDefaults (
  defaultRules
) where

import Development.Hake
import Development.Hake.FunSetRaw

defaultRules :: [ Rule ]
defaultRules = [

 rule ".o" ".c" $ \t (s:_) -> [ [ "cc", "-c", "-o", t, s ] ]

 ]
