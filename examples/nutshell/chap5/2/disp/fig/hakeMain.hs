import Development.Hake
import Development.Hake.FunSetRaw
import HakeDefaults

allT = "all"
mods = [ "fill.o", "rotat.o" ]

main = hake $ defaultRules ++ [

 dflt [ allT ]
 ,
 file [ allT ] mods $ const []
 ,
 task "clean" $ [ [ "rm", "-f" ] ++ mods ]

 ]
