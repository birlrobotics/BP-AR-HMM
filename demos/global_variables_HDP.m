function global_variables()
clear global;
clc; 
global rootPath rootDATApath modelPath                            %path
global METHOD ROBOT TASK STATE SIGNAL_TYPE TRUNCATION_STATES TRUNCATION_COMPONENTS %experiment set up
global TRAINING_SIM_REAL TRAINING_SUCCESS_FAILURE TRAINING_DATASET TRAINING_DATASET_PATH PLOT_SAVE saveDir Niter %training
global TESTING_SIM_REAL TESTING_SUCCESS_FAILURE TESTING_DATASET TESTING_DATASET_PATH TESTING_RESULTS_PATH %testing
global THRESHOLD_PATH DIS_PERIOD TIME_STEP R_Torques_diff MULTIMODAL COLORS PREPROCESSING_ON
global TRUE_POSITIVE  FALSE_NEGATIVE FALSE_POSITIVE TRUE_NEGATIVE CONST_C CONFUSION_MATRIX TIME_PERCENT

%% HIRO-Snap Assembly
%
%Customlize items
METHOD                      = 'sHDPHMM'; %sHDPHMM, HDPVARHMM(1),HDPVARHMM(2)
SIGNAL_TYPE                 = {'R_Torques','R_Angles'}; %'R_Torques'  %'R_Angles'
R_Torques_diff              = true;
PREPROCESSING_ON            = true;
PLOT_SAVE                   = false;
rootPath                    = 'F:\Matlab\NPBayesHMM\HDPHMM_HDPSLDS';
rootDATApath                = 'F:\Matlab\NPBayesHMM\DATA_HIRO_SA';
ROBOT                       = 'HIRO';
TASK                        = 'SA';
STATE                       = {'APPROACH', 'ROTATION', 'INSERTION', 'MATING'};
%for training
TRAINING_SIM_REAL           = 'REAL';    %REAL SIM
TRAINING_SUCCESS_FAILURE    = 'SUCCESS'; %SUCCESS
TRAINING_DATASET            = 'REAL_HIRO_ONE_SA_SUCCESS';%REAL_HIRO_ONE_SA_SUCCESS SIM_HIRO_ONE_SA_SUCCESS
%for testing
TESTING_SIM_REAL            = 'REAL'; %REAL SIM
TESTING_SUCCESS_FAILURE     = 'SUCCESS'; % SUCCESS FAILURE
TESTING_DATASET             = 'REAL_HIRO_ONE_SA_SUCCESS'; %REAL_HIRO_ONE_SA_SUCCESS, REAL_HIRO_ONE_SA_ERROR_CHARAC
%}

%{
%% BAXTER-Pick and Place
%Customlize items
METHOD                      = 'HDPVARHMM(1)'; %sHDPHMM, HDPVARHMM(1),HDPVARHMM(2)
SIGNAL_TYPE                 = {'R_Angles'}; %'R_Torques'  %'R_Angles'
R_Torques_diff              = false;
PREPROCESSING_ON            = true;
PLOT_SAVE                   = true;
rootPath                    = 'F:\Matlab\NPBayesHMM\HDPHMM_HDPSLDS';
rootDATApath                = 'F:\Matlab\NPBayesHMM\DATA_BAXTER_PICK_N_PLACE';
ROBOT                       = 'BAXTER';
TASK                        = 'PICK_N_PLACE';
STATE                       = {'GoPICK', 'PICK', 'GoPLACE', 'PLACE'};
%for training
TRAINING_SIM_REAL           = 'REAL';    %REAL SIM
TRAINING_SUCCESS_FAILURE    = 'SUCCESS'; %SUCCESS
TRAINING_DATASET            = 'REAL_BAXTER_SUCCESS';%REAL_HIRO_ONE_SA_SUCCESS SIM_HIRO_ONE_SA_SUCCESS
%for testing
TESTING_SIM_REAL            = 'REAL'; %REAL SIM
TESTING_SUCCESS_FAILURE     = 'SUCCESS'; % SUCCESS FAILURE
TESTING_DATASET             = 'REAL_BAXTER_SUCCESS'; %REAL_HIRO_ONE_SA_SUCCESS, REAL_HIRO_ONE_SA_ERROR_CHARAC
%}

%% 
%general initialization
TRUNCATION_STATES           = 20;    %states : truncation level of the DP(Dirichlet Process) prior on HMM transition distributions pi_k
TRUNCATION_COMPONENTS       = 1;     %components of mixture gaussian: truncation level of the DPMM(Dirichlet Process Mixture Model) on emission distributions pi_s
DIS_PERIOD                  = 50;    %define the display period for echoing the the screen
TIME_STEP                   = 0.005; %time-step for recording the signals
CONST_C                     = 2;     %for calculating the threshold: threshold = mu - CONST_C * std.
COLORS                      = {'r', 'g', 'b', 'k', 'c', 'm', 'y'};
MULTIMODAL                  = ''; 
for nSignal                 = 1 : length(SIGNAL_TYPE) 
    if strcmp(SIGNAL_TYPE(nSignal), 'R_Torques') & R_Torques_diff 
        MULTIMODAL          = strcat(MULTIMODAL,'R_Torques_diff_');
    else
        MULTIMODAL          = strcat(MULTIMODAL,SIGNAL_TYPE{nSignal},'_');
    end
end

addpath(genpath(rootPath));
addpath(genpath(rootDATApath));

%only for training
TRAINING_DATASET_PATH       = strcat(rootDATApath,'/',TRAINING_DATASET);
modelPath                   = strcat(rootPath,'/Trained_Models','/',METHOD,'_',TRAINING_SIM_REAL,'_',TRAINING_SUCCESS_FAILURE,'_',ROBOT,'_',TASK,'_',MULTIMODAL);
saveDir                     = strcat(rootPath,'/saveDir');
Niter                       = 500;

% only for testing
TESTING_DATASET_PATH        = strcat(rootDATApath,'/',TESTING_DATASET);
TESTING_RESULTS_PATH        = strcat(rootPath,'/Results','/',METHOD,'_',TESTING_SIM_REAL,'_',TESTING_SUCCESS_FAILURE,'_',MULTIMODAL);

%only for calculate state_threshold
THRESHOLD_PATH              = strcat(rootPath,'/Thresholds/',METHOD,'_',MULTIMODAL);

% failure detection for calculating the ROC curve
TRUE_POSITIVE               = 0;  % SUCCESS -> predicted as -> SUCCESS
FALSE_NEGATIVE              = 0;  % SUCCESS -> predicted as ->  FAILURE
FALSE_POSITIVE              = 0;  % FAILURE -> predicted as ->  SUCCESS 
TRUE_NEGATIVE               = 0;  % FAILURE -> predicted as ->  FAILURE 

% state classification accuracy for generating the confusion matrix and time threshold
CONFUSION_MATRIX            = zeros(length(STATE), length(STATE));
TIME_PERCENT                = zeros(1, length(STATE));
end

