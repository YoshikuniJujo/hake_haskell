import Development.Hake
import Development.Hake.FunSetIO
import HakeDefaults
import System.Process (runProcess, waitForProcess)
import System.Directory (setCurrentDirectory, getCurrentDirectory)

target         = "disp"
objs           = mainO : fig_objs ++ structops_objs
mainO          = "main.o"
fig_objs       = [ "fig/fill.o", "fig/rotat.o" ]
structops_objs = [ "structops/allocate.o", "structops/delete.o" ]

main = do
  setCurrentDirectory "fig"
  hakefileIs "Hakefile" []
  setCurrentDirectory "../structops"
  hakefileIs "Hakefile" []
  setCurrentDirectory "../"
  hake $ defaultRules ++ [

   dflt [ target ]
   ,
   file [ target ] objs $
     \t -> rawSystemE $ [ "cc", "-o", t ] ++ objs
   ,
   task "clean" $ rawSystemE $ [ "rm", "-f", target ] ++ objs

   ]
