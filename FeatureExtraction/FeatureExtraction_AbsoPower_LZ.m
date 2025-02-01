%Feature extraction scriptfor absolute power and LZ from normalised data

clear all; 
DATADIR = '/Volumes/Harddrive/Project_Data_Normalised/';
SAVEDIR = '/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/mat/';

cd(DATADIR)

filelist = {dir("*.mat").name};                     % List all .mat files and create cell array of file names 
filelist = filelist(~contains(filelist, '._'));     % Excludes hidden files 

% Define the desired order of electrode labels
ordered_labels = {'Fp1', 'Fp2', 'F3', 'F4', 'C3', 'C4', 'P3', 'P4', 'O1', 'O2', 'F7', 'F8', 'T7', 'T8', 'P7', 'P8', 'Fz', 'Cz', 'Pz', 'Oz', 'FC1', 'FC2', 'CP1', 'CP2', 'FC5', 'FC6', 'CP5', 'CP6', 'TP9', 'TP10', 'POz', 'FCz'};

%Label features 
feature_list = {'AbsoPowerDelta', 'AbsoPowerTheta', 'AbsoPowerAlpha', 'AbsoPowerBetaLow', 'AbsoPowerBetaHigh', 'AbsoPowerGamma', 'LZ', 'EntropyRt', 'HilbertLZ', 'EntropyRt_hilbert'};

%Initialise feature matrix 
num_features = length(ordered_labels) * length(feature_list); %Each feature per channel 
num_subjects = length(filelist); 

feature_matrix = NaN(num_subjects, num_features);   %Initialise dimensions, fill with NaNs

%Create column names 
feature_names = cell(1, num_features); %Initialise array with 1 row x num_features columns 
feature_count = 1;                     %To index feature names and add sequentially 
for i = 1:length(feature_list)         %For all features
    for j = 1:length(ordered_labels)   %For all channels
        feature_names{feature_count} = [feature_list{i} '_' ordered_labels{j}]; %create name with label name and feature name 
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
    absopower_features = struct2array(kate_Power(data));
    lz_features = struct2array(kate_LZc(data)); 

    %Flatten features row by row - remember to check that order aligns with labels (else transpose) 
    flattened_absopower_features = reshape(absopower_features, 1, []);
    flattened_lz_features = reshape(lz_features, 1, []);
    
    % Concatenate all features for this participant into one vector
    all_features_vector = [flattened_absopower_features, flattened_lz_features];
    
    % Store the concatenated feature vector in the corresponding row of the feature_matrix
    feature_matrix(i, :) = all_features_vector;

    %Return to data directory 
    cd(DATADIR)

end

% Save the feature matrix and names
save(fullfile(SAVEDIR, 'EEG_features.mat'), 'feature_matrix');
save(fullfile(SAVEDIR, 'EEG_feature_names.mat'), 'feature_names');



