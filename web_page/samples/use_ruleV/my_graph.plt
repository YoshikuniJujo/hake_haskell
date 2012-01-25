set terminal png
set output "my_graph.png"
plot "my_graph.dat" using 1:2 with lp, "common.dat" using 1:2 with lp
