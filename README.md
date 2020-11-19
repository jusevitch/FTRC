# FTRC

Implementation of the Finite-Time Resilient Consensus Protocol.

This repository contains the code used in the paper [_Resilient Finite-Time Consensus: A Discontinuous Systems Perspective_](https://arxiv.org/abs/2002.00040) by James Usevitch and [Dimitra Panagou](http://www-personal.umich.edu/~dpanagou/) from the University of Michigan Aerospace Engineering Department.

## Instructions for Running

1. Clone the repo, and navigate to the repo folder in MATLAB. 

2. Create a `struct` with the following fields:
  * `n`: An integer for the number of total agents.
  * `k`: The integer parameter for the [k-circulant network communication structure](https://arxiv.org/abs/1710.01990).
  * `type`: A string specifying the type of circulant graph for the communication structure. Set this variable as `kdir` for a directed k-circulant graph, or `kundir` for an undirected circulant graph.
  
3. Run the main function `FTRC`. A plot will automatically be generated.
  
  
Example code:
  ```
  args.n = 15;
  args.k = 11;
  args.type = 'kdir';
  
  data = FTRC(args); % This runs the main function.
  ```
  
  **Note:** The function `FTRC` automatically determines the maximum number of adversaries that the network can tolerate and uses this maximum number. This is the variable `F` in the function `FTRC`.
