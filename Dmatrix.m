function matrix = Dmatrix(numNodes, edges, special, kronecker)
% DMATRIX  Creates an incidence matrix based on a number of nodes and a
% vector of edges.
%   numNodes : Number of nodes in the graph
%   edges : vector of edges. Each row is an edge with the following format:
%       [head, tail]. The edges are assumed to be in the order of their 
%       labels, if any exist.

[n,m] = size(edges);
matrix = zeros(numNodes,n);

if strcmp(special,'arbcomplete') % Form an arbitrarily oriented incidence matrix for a complete graph
    k = 1; % Increasing variable to keep track of current column in D matrix
    % i iterates from 1 to the second to last node
    for i=1:1:numNodes
        % j iterates from i+1 to the last node
        for j=(i+1):1:numNodes
            matrix(i,k) = 1;
            matrix(j,k) = -1;
            k = k+1;
        end
    end
elseif strcmp(special, 'path') % Form a line graph. First node is head, last node is tail.
    k = 1;
    for i=1:1:numNodes-1
        matrix(i,k) = 1;
        matrix(i+1,k) = -1;
        k = k+1;
    end
else
    for i=1:1:n
        % Head assigned 1, Tail assigned -1.
       % The column is the edge number i. The row corresponds to the head and
       % tail node numbers.
        matrix(edges(i,1),i) = 1;
        matrix(edges(i,2),i) = -1;
    end
end

% Create a Kronecker D matrix if kronecker = 1
if nargin == 4
    if kronecker == 1
        matrix = kron(matrix,eye(2)); % For 3D case, use eye(3)
    end
end
end