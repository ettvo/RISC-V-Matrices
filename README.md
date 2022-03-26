# 61C Spring 2022 Project 2: CS61Classify

Spec: [https://cs61c.org/sp22/projects/proj2/](https://cs61c.org/sp22/projects/proj2/)

TODO: describe what you did

Part A:
the biggest trouble for part A was getting the hang of register convention because I kept having to refer to a chart (kept forgetting)
also ReLU was a bit of trouble with having to keep doing branches while continuing a loop
dot product was also really interesting with all the stuff involving strides
matrix multiplication was also very troublesome to debug at times (i.e. i put addi instead of add or used the wrong dimensions for something)

Part B:
last 3 tasts (read_matrix, write_matrix, classify) were fairly straightforward and easy to program
the biggest issue was with classify where forgetting to set a register or not malloc'ing correctly or providing the wrong dimensions were all easy mistakes to make
all in all, read_matrix and write_matrix were good practice functions for RISC-V
spent a lot of time trying to figure out what the last item that wasn't freed was
