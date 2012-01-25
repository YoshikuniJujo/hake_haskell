import Development.Hake
import Development.Hake.FunSetRaw
import HakeCommon

trgt   = "full_test"
objs   = [ "trac.o", "main.o" ]
cflags = [ "-DBSD", "-DSTAT" ]

main = hake $ commonRules cflags ++ [

 dflt [ trgt ]
 ,
 file [ trgt ] objs $ \t -> [ [ "cc", "-o", t ] ++ objs ]
 ,
 task "clean" [ [ "rm", "-f", trgt ] ++ objs ]

 ]
