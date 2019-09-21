% Implementation of the finite time FTRC Protocol

clear all
clc

n = 15;
k = 5;
type = 'kdir'; % 'kdir' or 'kundir'

args.n = n;
args.k = k;
args.type = type;

F = determineF(args);

maxsteps = 500;
dt = .1;

% Nonlinear function
g = @x3;

% Create the communication graph

L = makegraph(args);

% Define the misbehaving and behaving agents

rng('shuffle')
misbehaving = randsample(n,F);

normal = 1:n;
normal(misbehaving) = [];

% Generate the data

initial_state = 50*rand(n,1) - 25;

datamatrix = zeros(n,maxsteps);
datamatrix = [initial_state datamatrix];




% Plot the data





%%% Functions

% Dumb, but essential
function outscalar = identity(y)
    outscalar = y
end

% Any odd polynomial can be used. Make sure to scale down the slope to
% avoid numerical errors.
function outscalar = x3(y)
    outscalar = (1/500)*y^3;
end


