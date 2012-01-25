import Development.Hake
import Development.Hake.FunSetIO

main = hake [

 file [ "program" ] [ "main.o", "iodat.o", "dorun.o", "lo.o", "./usr/fred/lib/crtn.a" ] $
   const $ rawSystemE [ "cc", "-o", "program", "main.o", "iodat.o", "dorun.o", "lo.o", "./usr/fred/lib/crtn.a" ]
 ,
 file [ "main.o" ] [ "main.c" ] $ const $ rawSystemE [ "cc", "-c", "main.c" ]
 ,
 file [ "iodat.o" ] [ "iodat.c" ] $ const $ rawSystemE [ "cc", "-c", "iodat.c" ]
 ,
 file [ "dorun.o" ] [ "dorun.c" ] $ const $ rawSystemE [ "cc", "-c", "dorun.c" ]
 ,
 file [ "lo.o" ] [ "lo.s" ] $ const $ rawSystemE [ "cc", "-c", "lo.s" ]
 ,
 task "clean" $ rawSystemE [ "rm", "main.o", "iodat.o", "dorun.o", "lo.o", "program" ]

 ]
