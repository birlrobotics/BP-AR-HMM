clc  ;
close all;
clear global;
global_variables;

global STATE TRAINED_MODEL_PATH
trialIdx     ={'06', '07','08', '09','10'};
trainSTATE  = [1, 2, 3, 4];
for nState = trainSTATE  %1: length(STATE)
    close all;
    TrainedModelPath  = strcat(TRAINED_MODEL_PATH, char(STATE(nState)));
    if (exist(TrainedModelPath,'dir') == 0)
        mkdir(TrainedModelPath);
    end
    cd (TrainedModelPath);
    delete *;
    train_state (nState, trialIdx, TrainedModelPath);
end