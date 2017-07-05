%@Hongmin Wu 11-08, 2016
%@Hongmin Wu 05-23, 2017
%Extract the same file in different folder, e.g   R_Torques.dat
function [DataCell, R_State, folders_name] = load_data(datasetPath, trialID) 
    global SIGNAL_TYPE R_Torques_diff
    DataCell       = {};
    folders_name   = {};
    R_State        = {};
    for fid = 1:length(trialID)
        folders = [];
        data    = [];
        Rstate  = [];
        folders = dir([datasetPath, strcat('/*',trialID{fid})]);  
        folders_name = [folders_name, {folders.name}];      
        for j = 1: length(SIGNAL_TYPE)
            raw_data = load(strcat(datasetPath,'/',folders.name,'/',char(SIGNAL_TYPE(j)),'.dat'));
            d = raw_data(:,2:end);  %delete the time column
           if strcmp(SIGNAL_TYPE(j), 'R_Torques') & R_Torques_diff            
                d = [d,[d(1,:);diff(d)]];
           end
        if size(d, 1) ~= size(data, 1) & ~isempty(data)
            len = min([size(d, 1), size(data, 1)]);
            data(len:end,:) = [];
            d(len:end,:)    = [];
        end
        data = [data, d];    
        end
        data = data';
        
        DataCell = [DataCell; {data}];
      
        tstate  = load(strcat(datasetPath,'/',folders.name,'/','R_State.dat'));
        for in = 1:length(tstate)
            idex= find(raw_data(:,1) == tstate(in));
            Rstate = [Rstate, idex];
        end
        Rstate = [Rstate,length(data)];
        R_State = [R_State, {Rstate}];       
    end
end