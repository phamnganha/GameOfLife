Game of life in haskell for course project


Description

The game is based on cells stored in a two-dimensional board. Each cell is either empty or living. 

Rules

Given an initial configuration of the board, the next configuration is obtained by the following rules:

a living cell will survives if it has exactly 2 or 3 neighbouring living cells, 

and an empty cell will be born as a living cell if it has exactly 3 neighbours living cells, and remains empty otherwise.

How to run 

We compile the program by the command: ghci gameoflife.hs

then we run it by the command: gameoflife example

in this command, example is a list of living cells, and gameoflife is the main function. We can modify the example to see different running results
