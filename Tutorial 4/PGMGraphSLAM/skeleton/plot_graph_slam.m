function [] = plot_graph_slam(muRob, muMap, map, truePose, odometry, plotMuRob, plotMuMap, plotMap, plotTruePose, plotOdometry, plotMuMapLines)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if plotMuMapLines
    for i = 1:size(muMap, 2)
      plot([muMap(1,i) map(1,i)], [muMap(2,i) map(2,i)]);
    end
end
if plotTruePose
    plot(truePose(1,:), truePose(2,:), 'gx');
end
if plotOdometry
    plot(odometry(1,:), odometry(2,:), 'bx'); % cellfun(@(x) plot(x.odometry(1), x.odometry(2), 'bx'), simSteps,'UniformOutput',false);
end
if plotMap
    plot(map(1,:), map(2,:), 'ko');
end
if plotMuRob
    plot(muRob(1,:), muRob(2,:), 'r.');
end
if plotMuMap
    plot(muMap(1,:), muMap(2,:), 'rs');
end
end

