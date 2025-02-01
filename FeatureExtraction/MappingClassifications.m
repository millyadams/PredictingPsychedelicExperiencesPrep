%maps labels for python compatability 
clear all; 
load('/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/mat/feature_df_ARL.mat');

% Change the labels from 1 and 2 to 0 and 1
labels = feature_df{:, 2:5};

labels(labels == 1) = 0;
labels(labels == 2) = 1;
feature_df{:, 2:5} = labels;

% Save the modified data to a new .mat file
save('feature_df_mapped_ARL.mat', 'feature_df');

writetable(feature_df, '/Users/millyadams/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Research Project/Data/PredictingExperiences_Paper/FollowUp_Paper/FeatureExtraction/Relative_and_Absolute/CSV/feature_df_mapped_ARL.csv');
