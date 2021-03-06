% 
%      ____  ___   _____ ______   __          __    
%     / __ \/   | / ___// ____/  / /   ____ _/ /_   
%    / / / / /| | \__ \/ /      / /   / __ `/ __ \  
%   / /_/ / ___ |___/ / /___   / /___/ /_/ / /_/ /  
%  /_____/_/  |_/____/\____/  /_____/\__,_/_.___/   
%                                                   
% 
% (C) 2020 James Usevitch
% University of Michigan Aerospace Engineering

function outscalar = determineF(args)

% args:
%   n : number of nodes
%   k : parameter k determining connections for k-circulant graphs
%   graph : string specifying graph type. Choose from 'kdir' for
%           k-circulant digraphs or 'kundir' for k-circulant undirected
%           graphs


if strcmp(args.type,'kdir')
    if mod(args.k,2) == 0
        outscalar = floor((args.k+2)/4)-1;
    else
        outscalar = floor((args.k+3)/4)-1;
    end
elseif strcmp(args.type, 'kundir')
    if mod(args.k,2) == 0
        outscalar = floor((args.k+1)/2)-1;
    else
        outscalar = floor((args.k+2)/2)-1;
    end
end


end