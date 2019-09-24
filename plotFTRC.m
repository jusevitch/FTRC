function plotFTRC(args)

% Number of rows of data: number of agents
% Number of columns: number of time steps

% varargin:
%   (1) : vector of normal agents
%   (2) : vector of misbehaving agents

data = args.data;
normal = args.normal;
misbehaving = args.misbehaving;

clf
figure(1)
tvec = 1:size(data,2);

hold on
np = plot(tvec,data(normal,:));
mp = plot(tvec,data(misbehaving,:),'r--');

ylim([-5,55]);
xlabel('Time step');
ylabel('State Value');
legend([np(1), mp(1)], 'Normal Agents', 'Misbehaving Agents');



end