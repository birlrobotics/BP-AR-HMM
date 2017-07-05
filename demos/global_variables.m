function global_variables()
global ROOT_PATH DATA_PATH TRAINED_MODEL_PATH TESTING_RESULTS_PATH %path
global METHOD ROBOT TASK STATE SIGNAL_TYPE DATASET TIME_STEP COLORS PLOT_SAVE                 %general
global TRAIN_TIMES  INERATIVE_TIMES  R_Torques_diff PREPROCESSING_ON AUTOREGRESSIVE_ORDER     %parameters
global CONFUSION_MATRIX TIME_PERCENT

AUTOREGRESSIVE_ORDER = 1;
TRAIN_TIMES          = 1;
INERATIVE_TIMES      = 500;
TIME_STEP            = 0.005;
COLORS               = {'r', 'g', 'b', 'k', 'c','y'};
METHOD               = 'BPARHMM';
ROBOT                = 'HIRO';
TASK                 = 'SA';
SIGNAL_TYPE          = {'R_Torques','R_Angles'};  %'R_Torques', 'R_Angles' 
R_Torques_diff       = false;
PREPROCESSING_ON     = true;
PLOT_SAVE            = false;
MULTIMODAL           = '';
for nSignal                 = 1 : length(SIGNAL_TYPE) 
    if strcmp(SIGNAL_TYPE(nSignal), 'R_Torques') & R_Torques_diff 
        MULTIMODAL          = strcat(MULTIMODAL,'R_Torques_diff_');
    else
        MULTIMODAL          = strcat(MULTIMODAL,SIGNAL_TYPE{nSignal},'_');
    end
end

DATASET              = 'REAL_HIRO_ONE_SA_SUCCESS';
DATA_PATH            = 'F:\Matlab\NPBayesHMM\DATA_HIRO_SA';
ROOT_PATH            = 'F:\Matlab\NPBayesHMM\BPARHMM';
TRAINED_MODEL_PATH   = strcat(ROOT_PATH, '/','TrainedModels/',METHOD,'_',ROBOT,'_',TASK,'_',MULTIMODAL,'_');
TESTING_RESULTS_PATH = strcat(ROOT_PATH, '/','Results/',METHOD,'_',ROBOT,'_',TASK,'_',MULTIMODAL);
STATE                = {'APPROACH', 'ROTATION', 'INSERTION', 'MATING'};

%{
DATASET              = 'REAL_BAXTER_SUCCESS';
DATA_PATH            = 'F:\Matlab\NPBayesHMM\DATA_BAXTER_PICK_N_PLACE';
STATE                = {'GoPICK', 'PICK', 'GoPLACE', 'PLACE'};
%}

addpath(genpath(ROOT_PATH));
addpath(genpath(DATA_PATH));

% state classification accuracy for generating the confusion matrix and time threshold
CONFUSION_MATRIX            = zeros(length(STATE), length(STATE));
TIME_PERCENT                = zeros(1, length(STATE));
end
