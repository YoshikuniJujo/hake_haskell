import Development.Hake
import Development.Hake.FunSetRaw
import System.Environment (getArgs)
import Control.Applicative ((<$>))

main = do
  args <- getArgs
  let add  = getVals "add" args
      add2 = getVals "add2" args
  hake [

   dflt [ "task1" ]
   ,
   file [ "task1" ] [ "task2" ] $ (:[]) . ("echo":) . (:[])
   ,
   task "task2"
     [ [ "echo", "task2"] , [ "./exitWith", "123" ], [ "echo", "task2", "running" ],
       [ "./exitWith", "123" ] ]

   ]
