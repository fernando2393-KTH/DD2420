classdef SimStep
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    t
    odometry
    encoder
    truePose
    seenLandmarks
  end
  
  methods
    function obj = SimStep(values)
      obj.t = values(1);
      obj.odometry = values(2:4);
      obj.encoder = values(5:6);
      obj.truePose = values(7:9);
      
      ids = values(11:3:end);
      bearings = values(12:3:end);
      ranges = values(13:3:end);
      
      obj.seenLandmarks = [ranges,bearings,ids]';
    end
    
    function numLandmarks = getNumLandmark(obj)
      %METHOD1 Summary of this method goes here
      %   Detailed explanation goes here
      numLandmarks = size(obj.seenLandmarks,2);
    end
    
    function landmark = getLandmark(obj,index)
      %METHOD1 Summary of this method goes here
      %   Detailed explanation goes here
      landmark = obj.seenLandmarks(:,index);
    end
    
    function range = getLandmarkRange(obj,index)
      %METHOD1 Summary of this method goes here
      %   Detailed explanation goes here
      range = obj.seenLandmarks(1,index);
    end
    
    function bearing = getLandmarkBearing(obj,index)
      %METHOD1 Summary of this method goes here
      %   Detailed explanation goes here
      bearing = obj.seenLandmarks(2,index);
    end
    
    function id = getLandmarkID(obj,index)
      %METHOD1 Summary of this method goes here
      %   Detailed explanation goes here
      id = obj.seenLandmarks(3,index);
    end
    
    function answer = containsLandmark(obj,id)
        answer = any(obj.seenLandmarks(3,:) == id);
    end
  end
end

