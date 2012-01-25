import Development.Hake
import Development.Hake.FunSetRaw

target = "hello"

main = hake [

 dflt [ target ]
 ,
 rule "" ".c" $ \t (s:_) -> [ [ "cc", "-o", t, s ] ]
 ,
 task "clean" [ [ "rm", "-f", target ] ]

 ]
