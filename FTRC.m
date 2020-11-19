% 
%      ____  ___   _____ ______   __          __    
%     / __ \/   | / ___// ____/  / /   ____ _/ /_   
%    / / / / /| | \__ \/ /      / /   / __ `/ __ \  
%   / /_/ / ___ |___/ / /___   / /___/ /_/ / /_/ /  
%  /_____/_/  |_/____/\____/  /_____/\__,_/_.___/   
%                                                   
% 
% (C) 2020 James Usevitch

function outstruct = FTRC(args)

% Implementation of the finite time FTRC Protocol from the paper "Resilient
% Finite-Time Consensus: A Discontinuous Systems Perspective" by James
% Usevitch and Dimitra Panagou

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
F = 2

maxsteps = 50000;
dt = .0001;

% Nonlinear function
% g = @x3;
g = @x3x5x7;

alpha = 10; % weight for signum function

a = 250; % for adversaries
b = -250; % for adversaries

% Create the communication graph

L = makegraph(args);
A = diag(diag(L)) - L; % Adjacency matrix

% Define the misbehaving and behaving agents

rng('shuffle')
misbehaving = randsample(n,F);

normal = 1:n;
normal(misbehaving) = [];

% Generate the data

initial_state = 50*rand(n,1);


data = zeros(n,maxsteps);
data = [initial_state data];

for tt=1:1:maxsteps
    data(:,tt+1) = FTRC_step(data(:,tt));
    if mod(tt,1000) == 0
        disp(['Time step ' num2str(tt) ' / ' num2str(maxsteps) ' completed (' num2str(round((tt / maxsteps)*100,3,'significant')) '%)'])
    end
end

outstruct.data = data;
outstruct.normal = normal;
outstruct.misbehaving = misbehaving;
outstruct.F = F;

plotFTRC(outstruct);

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

function outscalar = x3x5x7(y)
    beta1 = 10;
    beta2 = 1000;
    beta3 = 10000;
    outscalar = beta1*(y.^3) + beta2*(y.^5) + beta3*(y.^7);
end


function outvector = FTRC_step(state_vector)
    
    velocity_vector = zeros(n,1);
    
    % Misbehaving nodes
    for ii=misbehaving
        temp_vec = randi(2,length(misbehaving),1);
        velocity_vector(misbehaving(temp_vec == 1)) = a;
        velocity_vector(misbehaving(temp_vec == 2)) = b;
    end
    
    for jj=normal
        in_neib_states = state_vector(find(A(jj,:)));
        in_neib_states = g(in_neib_states);
        % Find states above and below x_jj
        upper_states = sort(in_neib_states(in_neib_states > g(state_vector(jj))),'descend');
        lower_states = sort(in_neib_states(in_neib_states < g(state_vector(jj))));
        % Filter out F largest and F smallest
        upper_states(1:min(F,length(upper_states))) = [];
        lower_states(1:min(F,length(lower_states))) = [];
        unfiltered_neib_states = [upper_states; lower_states];
        
        sum = ones(size(unfiltered_neib_states))'*(unfiltered_neib_states - g(state_vector(jj))*ones(size(unfiltered_neib_states)));
        if abs(sum) < .1
            sum = 0;
        end
        velocity_vector(jj) = alpha*sign(sum);
    end
    
    outvector = state_vector + dt*velocity_vector;
end

end
