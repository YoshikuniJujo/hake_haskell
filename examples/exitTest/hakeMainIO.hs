import Development.Hake
import Development.Hake.FunSetIO
import System.Environment (getArgs)
import Control.Applicative ((<$>))

main = do
  args <- getArgs
  let add  = getVals "add" args
      add2 = getVals "add2" args
  hake [

   dflt [ "task1" ]
   ,
   file [ "task1" ] [ "task2" ] $ rawSystemE . ("echo":) . (:[])
   ,
   task "task2" $ do
     rawSystemE [ "echo", "task2" ] `orDie` show
     (case add of
           [] -> flip orDie show
	   _  -> (>> rawSystemE add `orDie` show)) $
       rawSystemE [ "./exitWith", "123" ] 
     rawSystemE [ "echo", "task2", "running" ]
     (case add2 of
           [] -> (>> return ExitSuccess) . flip orDie show
	   _  -> (>> rawSystemE add2)) $
       rawSystemE [ "./exitWith", "123" ] 

   ]
