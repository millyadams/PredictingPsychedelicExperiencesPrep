%Feature extraction script for relative power from non-normalised data 

clear all; 
DATADIR = '/Volumes/Harddrive/Project_Data/';
SAVEDIR = '/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/mat/';

cd(DATADIR)

filelist = {dir("*.mat").name};                     % List all .mat files and create cell array of file names 
filelist = filelist(~contains(filelist, '._'));     % Excludes hidden files 

% Define the desired order of electrode labels
ordered_labels = {'Fp1', 'Fp2', 'F3', 'F4', 'C3', 'C4', 'P3', 'P4', 'O1', 'O2', 'F7', 'F8', 'T7', 'T8', 'P7', 'P8', 'Fz', 'Cz', 'Pz', 'Oz', 'FC1', 'FC2', 'CP1', 'CP2', 'FC5', 'FC6', 'CP5', 'CP6', 'TP9', 'TP10', 'POz', 'FCz'};

%Label features 
feature_list = {'RelPowerDelta', 'RelPowerTheta', 'RelPowerAlpha', 'RelPowerBetaLow', 'RelPowerBetaHigh', 'RelPowerGamma'};

%Initialise feature matrix 
num_features = length(ordered_labels) * length(feature_list); %Each feature per channel 
num_subjects = length(filelist); 

feature_matrix_rel = NaN(num_subjects, num_features);   %Initialise dimensions, fill with NaNs

%Create column names 
feature_names_rel = cell(1, num_features); %Initialise array with 1 row x num_features columns 
feature_count = 1;                     %To index feature names and add sequentially 
for i = 1:length(feature_list)         %For all features
    for j = 1:length(ordered_labels)   %For all channels
        feature_names_rel{feature_count} = [feature_list{i} '_' ordered_labels{j}]; %create name with label name and feature name 
        feature_count = feature_count + 1; 
    end
end

%Initiate loop - loop through each ppt 

for i = 1:num_subjects                         %i is the participant 
    filename = fullfile(DATADIR, filelist{i}); %Construct file path
    load(filename);                            %Load data 
    
    %Reorder labels in CI dataset  
    if contains(filename, 'CI_') %only reorders labels/electrodes if in CI dataset 
        current_labels = data.label;
        [~, idx] = ismember(ordered_labels, current_labels); %Find indices to reorder current_labels to match ordered_labels

        %Check if any labels do not exist in both 
        if any(idx == 0)
            warning('Some labels not found in %s', filename);
            continue; 
        end  

        data.label = data.label(idx); %Reorder labels - can change to 'ordered_labels' 
        for j = 1:length(data.trial)  %Reorder EEG data to align with labels 
            data.trial{j} = data.trial{j}(idx, :);
        end
    end
    
    %Script to extract only first X trials based on minimum ? 

    %Go to feature directory
    %feature_DIR = '/Volumes/Harddrive/Paper_followup/Feature_Extraction'; 
    feature_DIR = '/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Functions';
    cd(feature_DIR);
    %Each field in the structure becomes a column in the table, and the field names become the column names 
    relpower_features = struct2array(kate_PowerRelative(data));
    %Flatten features row by row - remember to check that order aligns with labels (else transpose) 
    flattened_relpower_features = reshape(relpower_features, 1, []);

    % Store the concatenated feature vector in the corresponding row of the feature_matrix
    feature_matrix_rel(i, :) = flattened_relpower_features;

    %Return to data directory 
    cd(DATADIR)

end

% Save the feature matrix and names
save(fullfile(SAVEDIR, 'EEG_features_rel.mat'), 'feature_matrix_rel');
save(fullfile(SAVEDIR, 'EEG_feature_names_rel.mat'), 'feature_names_rel');



