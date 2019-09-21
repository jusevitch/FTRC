function outmatrix = makegraph(args)

% Creates a Laplacian matrix for a given class of graphs
% Arguments:
%   args.n : number of nodes
%   args.k : parameter k (if applicable)
%   args.p : probability p (for Erdos-Renyi)
%   args.type : string specifying requested type of graph

if strcmp(args.type,'complete')
    %     Complete graph
    D = Dmatrix(args.n,[],'arbcomplete',0);
    outmatrix = D*D';
elseif strcmp(args.type,'kdir')
    % k-Circulant directed graph
    outmatrix = kCirculant(args.n,args.k,'dir');
elseif strcmp(args.type,'kundir')
    % k-Circulant undirected graph
    outmatrix = kCirculant(args.n,args.k,'undir');
elseif strcmp(args.type,'kplatoon')
    % k-nearest neighbor platoons;
    outmatrix = zeros(args.n);
    for ii=1:1:args.k
        outmatrix = outmatrix + diag(-ones(args.n - ii,1),ii) + diag(-ones(args.n-ii,1),-ii);
    end
    outmatrix = outmatrix + abs(diag(outmatrix*ones(args.n,1)));
elseif strcmp(args.type,'ErdosRenyi') || strcmp(args.type,'Erdos')
    A = ErdRen(args.n,args.p);
    outmatrix = diag(A*ones(args.n,1)) - A; % Returns matrix Laplacian
elseif strcmp(args.type,'randdigraph') || strcmp(args.type,'randdir')
    A = randDigraph(args.n,args.p);
    outmatrix = diag(A*ones(args.n,1)) - A; % Returns matrix Laplacian
elseif strcmp(args.type,'kinrand')
    A = kinRandDigraph(args.n,args.k);
    outmatrix = diag(A*ones(args.n,1)) - A; % Returns matrix Laplacian
elseif strcmp(args.type,'koutrand')
    A = koutRandDigraph(args.n,args.k);
    outmatrix = diag(A*ones(args.n,1)) - A; % Returns matrix Laplacian
else
    error('Sorry -- makegraph does not have that option')
end

end

% Internal functions
% NOTE: Many of these functions have been defined in standalone .m files.
% As per Matlab scope, the functions in this file will be called first
% rather than the external files.
%
% If anything is not behaving as expected, check for differences between
% these functions and the external files. You may have edited one but not
% edited the other, or vice versa.

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

function matrix = kCirculant(n,k,type)
% Creates Laplacian matrix for a k-circulant graph with n agents and with
% parameter k.

matrix = zeros(n);
if strcmp(type,'dir')
    for i=1:1:n
        for j=1:1:n
            if i == j
                matrix(i,j) = k;
            elseif i < j
                if ((mod(j+k,n)-i) < k) && ((mod(j+k,n)-i) >= 0)
                    matrix(i,j) = -1;
                end
            else
                if ((i-j)<=k)
                    matrix(i,j) = -1;
                end
            end
        end
    end
elseif strcmp(type,'undir')
    % Test to see if k is too large to make a proper graph or not. The code
    % only runs if ok == 1. If k is too big, ok is set to 0 and an error
    % message is displayed.
    ok = 1;
    if (mod(n,2) == 1) 
        if k > floor(n/2)
            ok = 0;
        end
    elseif (mod(n,2) == 0)
        if k >= (n/2)
            ok = 0;
        end
    end

    if ok == 0
        matrix = 'ERROR -- k too big'
    elseif ok == 1
        for i=1:1:n
            for j=1:1:n
                if i == j
                    matrix(i,j) = 2*k;
                else
                    if ((j+k > n) && mod(j+k,n) >= i) || ((i+k > n) && mod(i+k,n) >= j)
                        matrix(i,j) = -1;
                    elseif (abs(i-j)<=k)
                        matrix(i,j) = -1;
                    end
                end
            end
        end
    end
end
end

function outmatrix = ErdRen(n,p)
% Code is reworked from https://www.cs.purdue.edu/homes/dgleich/demos/matlab/random_graphs/erdosreyni.html

outmatrix = rand(n,n) < p;
outmatrix = triu(outmatrix,1);

outmatrix = outmatrix + outmatrix'; % Make matrix symmetric
outmatrix(find(outmatrix)) = 1;

end