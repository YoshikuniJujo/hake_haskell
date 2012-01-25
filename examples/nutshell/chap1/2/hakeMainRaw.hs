import Development.Hake
import Development.Hake.FunSetRaw

main = hake [

 file [ "plot_prompt" ] [ "basic.o", "prompt.o" ] $
   const [ [ "cc", "-o", "plot_prompt", "basic.o", "prompt.o" ] ]
 ,
 file [ "plot_win" ] [ "basic.o", "window.o" ] $
   const [ [ "cc", "-o", "plot_win", "basic.o", "window.o" ] ]
 ,
 file [ "basic.o" ] [ "basic.c" ] $ const [ [ "cc", "-c", "basic.c" ] ]
 ,
 file [ "prompt.o" ] [ "prompt.c" ] $ const [ [ "cc", "-c", "prompt.c" ] ]
 ,
 file [ "window.o" ] [ "window.c" ] $ const [ [ "cc", "-c", "window.c" ] ]
 ,
 task "clean" [ [ "rm", "-f", "plot_prompt", "plot_win", "basic.o", "prompt.o", "window.o" ] ]

 ]
