 clc;
clear;
clear global;
tic;
global_variables;
trialIdx = {'02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21'};
 for  idx=1:length(trialIdx) % for testing each state
    close all;
    %channel-#1
    
    static_test_state_classification(trialIdx(idx));  % push the whole data as the observation, and get the results directly.
    
    %channel-#2
    %dynamic_test_state(testing_trial); %Obtained the results by dynamical display the observation
 end
toc;