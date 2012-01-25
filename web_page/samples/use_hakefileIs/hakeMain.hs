import Development.Hake
import Development.Hake.FunSetRaw
import Variables

main = hake [

 dflt [ target ]
 ,
 rule "" ".c" $ \t (s:_) -> [ [ "cc", "-o", t, s ] ]

 ]
