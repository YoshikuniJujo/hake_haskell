import Development.Hake
import Development.Hake.FunSetIO

main = hake [

 file [ "plot_prompt" ] [ "basic.o", "prompt.o" ] $ const $ rawSystemE 
   [ "cc", "-o", "plot_prompt", "basic.o", "prompt.o" ]
 ,
 file [ "plot_win" ] [ "basic.o", "window.o" ] $ const $ rawSystemE
   [ "cc", "-o", "plot_win", "basic.o", "window.o" ]
 ,
 file [ "basic.o" ] [ "basic.c" ] $ const $ rawSystemE [ "cc", "-c", "basic.c" ]
 ,
 file [ "prompt.o" ] [ "prompt.c" ] $ const $ rawSystemE [ "cc", "-c", "prompt.c" ]
 ,
 file [ "window.o" ] [ "window.c" ] $ const $ rawSystemE [ "cc", "-c", "window.c" ]
 ,
 task "clean" $
   rawSystemE [ "rm", "-f", "plot_prompt", "plot_win", "basic.o", "prompt.o", "window.o" ]

 ]
