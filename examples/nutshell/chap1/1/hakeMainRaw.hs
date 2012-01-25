import Development.Hake
import Development.Hake.FunSetRaw

main = hake [

 file [ "program" ] [ "main.o", "iodat.o", "dorun.o", "lo.o", "./usr/fred/lib/crtn.a" ] $
   const [ [ "cc", "-o", "program", "main.o", "iodat.o", "dorun.o", "lo.o", "./usr/fred/lib/crtn.a" ] ]
 ,
 file [ "main.o" ] [ "main.c" ] $ const [ [ "cc", "-c", "main.c" ] ]
 ,
 file [ "iodat.o" ] [ "iodat.c" ] $ const [ [ "cc", "-c", "iodat.c" ] ]
 ,
 file [ "dorun.o" ] [ "dorun.c" ] $ const [ [ "cc", "-c", "dorun.c" ] ]
 ,
 file [ "lo.o" ] [ "lo.s" ] $ const [ [ "cc", "-c", "lo.s" ] ]
 ,
 task "clean" [ [ "rm", "main.o", "iodat.o", "dorun.o", "lo.o", "program" ] ]

 ]
