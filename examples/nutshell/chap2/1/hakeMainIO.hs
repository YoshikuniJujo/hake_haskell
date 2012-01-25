import Development.Hake
import Development.Hake.FunSetIO
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
   rule "" ".o" $ \t s -> rawSystemE $ [ "cc", "-o", t ] ++ filter (isSuffixOf ".o") s
   ,
   rule ".o" ".c" $ \t (s:_) -> rawSystemE $ [ "cc", "-c", "-o", t ] ++ cflags ++ [ s ]
   ,
   task "clean" $ fmap last $
     mapM (\t -> rawSystemE [ "rm", "-f", t, t ++ ".o", t ++ "_mod.o" ]) targets

   ] `addDeps`

   map (\t -> (t, [ t ++ "_mod.o" ])) targets
