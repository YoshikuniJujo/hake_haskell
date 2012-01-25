import Development.Hake
import Development.Hake.FunSetRaw
import System.Environment (getArgs)
import Control.Applicative ((<$>))

main = do
  args <- getArgs
  let dir    = getVals "dir" args
      cflags = getVals "cflags" args
      targets = map (++"/hello") dir
  hake $ [

   dflt targets
   ,
   rule "" ".o" $ \t s -> [ [ "cc", "-o", t ] ++ filter (isSuffixOf ".o") s ]
   ,
   rule ".o" ".c" $ \t (s:_) -> [ [ "cc", "-c", "-o", t ] ++ cflags ++ [ s ] ]
   ,
   task "clean" $ map (\t ->  [ "rm", "-f", t, t ++ ".o", t ++ "_mod.o" ]) targets

   ] `addDeps`

   map (\t -> (t, [ t ++ "_mod.o" ])) targets
