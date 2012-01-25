module Main where

import Development.Hake
import Development.Hake.FunSetRaw
import Variables

main = hake rules

rules = [
 dflt [ "hello" ]
 ,
 rule exeSffx objSffx $ \t s -> [ [cc, "-o", t] ++ s ]
 ,
 rule objSffx cSffx   $ \_ s -> [ [cc, "-c"] ++ s ]
 ,
 task "clean" [ ["rm", "hello" ++ exeSffx, "hello" ++ objSffx] ]
 ]
