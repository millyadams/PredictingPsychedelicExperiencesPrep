%Combine all features and save as CSV for use in python 

clear all;
%Load Absolute Power + LZ variable 
load('/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/mat/EEG_features.mat') %load feature matrix
load('/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/mat/EEG_feature_names.mat') %load column headings 
%Load Relative Power variables 
load('/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/mat/EEG_features_rel.mat') %load feature matrix
load('/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/mat/EEG_feature_names_rel.mat') %load column headings 


load('/Volumes/Harddrive/Feature_Extraction/Classification_Variables/New/classification_Oct2024.mat') %load classifications 

%load('/Volumes/Harddrive/Feature_Extraction/Classification_Variables/subjectIDs.mat') %load subject IDs

% Create table - add feature names as column 
feature_table = array2table(feature_matrix, 'VariableNames', feature_names);
feature_table_rel = array2table(feature_matrix_rel, 'VariableNames', feature_names_rel);

%check number of rows 
if height(classification) == height(feature_table) && height(feature_table) == height(feature_table_rel)
    disp('Number of rows aligns')
else 
    disp('Different number of rows, check for error')
end

feature_df = [classification, feature_table, feature_table_rel];

%Save as CSV to use in python 
writetable(feature_df, '/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/CSV/feature_df_ARL.csv');
%also save as .mat for later normalisation 
save('/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/mat/feature_df_ARL.mat', 'feature_df');




