set terminal png
set output "plot.png"
plot "plot.dat" using 1:2 title "some" w linespoints
