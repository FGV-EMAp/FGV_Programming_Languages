set terminal svg
set title 'Simulation Output'
set xlabel 'time'
set ylabel '%'
set style fill solid 0.3
set style data boxes
plot 'sim.csv'