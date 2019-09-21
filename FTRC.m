% Implementation of the finite time FTRC Protocol

function outmatrix = FTRC(args)

% args:
%   n : number of nodes
%   k : parameter k determining connections for k-circulant graphs
%   type : string specifying graph type. Choose from 'kdir' for
%           k-circulant digraphs or 'kundir' for k-circulant undirected
%           graphs
%

n = args.n;
k = args.k;

F = determineF(args);

maxsteps = 500;
dt = .1;

% Nonlinear function
g = @x3;

alpha = 3; % weight for signum function

a = 5 % for adversaries
b = -5 % for adversaries

% Create the communication graph

L = makegraph(args);
A = diag(diag(L)) - L; % Adjacency matrix

% Define the misbehaving and behaving agents

rng('shuffle')
misbehaving = randsample(n,F);

normal = 1:n;
normal(misbehaving) = [];

% Generate the data

initial_state = 50*rand(n,1) - 25;

outmatrix = zeros(n,maxsteps);
outmatrix = [initial_state outmatrix];





% Plot the data






%%% Functions

% Dumb, but essential
function outscalar = identity(y)
    outscalar = y;
end

% Any odd polynomial can be used. Make sure to scale down the slope to
% avoid numerical errors.
function outscalar = x3(y)
    outscalar = (1/500)*y.^3;
end


function outvector = FTRC_step(statevector)
    
    velocity_vector = zeros(n,1);
    
    % Misbehaving nodes
    for ii=misbehaving
        temp_vec = randi(2,length(misbehaving),1);
        velocity_vector(misbehaving(temp_vec == 1)) = a;
        velocity_vector(misbehaving(temp_vec == 2)) = b;
    end
    
    for jj=normal
        in_neib_states = statevector(A(jj,:));
        sum = ones(size(in_neib_states))'*(g(in_neib_states) - g(statevector(jj))*ones(size(in_neib_states)));
        velocity_vector(jj) = sign(sum);
    end
    
    outvector = state_vector + dt*velocity_vector;
end

end
