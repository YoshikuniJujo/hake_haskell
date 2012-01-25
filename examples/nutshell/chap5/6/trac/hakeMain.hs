import Development.Hake
import Development.Hake.FunSetRaw
import HakeCommon

trgt   = "trac"
objs   = [ "trac.o", "main.o" ]
cflags = [ "-DBSD" ]

main = hake $ commonRules cflags ++ [

 dflt [ trgt ]
 ,
 file [ trgt ] objs $ \t -> [ [ "cc", "-o", t ] ++ objs ]
 ,
 task "clean" [ [ "rm", "-f", trgt ] ++ objs ]

 ]
