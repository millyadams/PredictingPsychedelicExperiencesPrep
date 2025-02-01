%Script to k-means cluster MEQ data based on total MEQ score
%For other experience types, update the relevant lines as noted in the README file  

clear all; 

% 1. Load data

% Define paths for subjective experience data 
% Note - this script concatanates three datasets 
CI_MEQ_path = '/Volumes/Harddrive/Subjective_Data/MEQ_Variables/CI_MEQ.mat'; %path to data 
Imaging_MEQ_path = '/Volumes/Harddrive/Subjective_Data/MEQ_Variables/Imaging_MEQ.mat';
Pilot_MEQ_path = '/Volumes/Harddrive/Subjective_Data/MEQ_Variables/Pilot_MEQ.mat';

load(CI_MEQ_path, 'CI_MEQ');
load(Imaging_MEQ_path, 'Imaging_MEQ');
load(Pilot_MEQ_path, 'Pilot_MEQ');

% 2. Creat cell array for clustering 

% Convert to numeric array for k-means clustering 
MEQ_CI = table2array(CI_MEQ(:,6));
MEQ_Imaging = table2array(Imaging_MEQ(:,6));
MEQ_Pilot = table2array(Pilot_MEQ(:,6));

% Combine data into a cell array 
% Note - skip this step if you have a singular dataset 
all_total_MEQ = [MEQ_CI; MEQ_Imaging; MEQ_Pilot];
%all_total_MEQ = [all_total_MEQ, zeros(size(all_total_MEQ))]; % Add a second column (dummy variable) for older versions of matlab

% 3. K-mean clustering 

k = 2; %define two clusters for binary classification problem
[idx, centroids] = kmeans(all_total_MEQ, k); %default uses Euclidean distance 

%Visualise in scatter plot 
figure;
scatter(all_total_MEQ, ones(size(all_total_MEQ)), 50, idx, 'filled'); % Scatter plot coloured by cluster                                                       %Note - plot against vector of ones as only clustered on one feature 
hold on;

plot(centroids, [1, 1], 'kx', 'MarkerSize', 15, 'LineWidth', 3); % Plot centroids
xlabel('Overall MEQ Score');
ylabel('Cluster');
title('K-means Clustering of MEQ Scores');

saveas(gcf, 'kmeans_total_MEQ.png'); %save figure 
%% 4. Interpret clusters 
%Centroids represent the mean values of clusters - compare centroids 
disp(['Cluster 1 av:', num2str(centroids(1))]);
disp(['Cluster 2 av:', num2str(centroids(2))]);

% Identify which group represents mystical experiences 
% Higher values define the mystical expreince group, so this is the centroid with the higher average 
if centroids(1) > centroids(2)
    disp('Cluster 1 = mystical experience');
else
    disp('Cluster 2 = mystical experience');
end

%% 4. Create a variable containing classifications 

class = idx; % Stores labels for each subject from k means output 

load('/Volumes/Harddrive/Feature_Extraction/Classification_Variables/subjectIDs.mat'); %load IDs
subjectIDs = subjectIDs';

% Create table mapping each subject ID to the MEQ label 
MEQ_class = table(subjectIDs, class, 'VariableNames', {'SubjectID', 'MEQ_Class'});

SAVEDIR = '/Volumes/Harddrive/Feature_Extraction';
filename = fullfile(SAVEDIR, 'MEQ_class.mat'); 
save(filename, 'MEQ_class'); 


%% 5. Identify threshold (optional) 

% Midpoints between centroids as threshold 
threshold_kmeans = mean(centroids); %Identify midpoint between centroids 

% Classify participants based on threshold value between centroids 
class_ME = all_total_MEQ >= threshold_kmeans; %stored as True is over threshold, False if unfer threshold 

% Visualize classification with threshold 
figure;
histogram(all_total_MEQ, 'BinWidth', 0.25);
hold on;
plot([threshold_kmeans, threshold_kmeans], ylim, 'r--', 'LineWidth', 2); %plots threshold line 
xlabel('Overall MEQ Score');
ylabel('Frequency');
title('Classifying using K-means')
legend('Overall MEQ Scores', 'Threshold');

saveas(gcf, 'kmeans_total_MEQ_threshold.png');
%% 6. Pre-defined threshold (optional) 
% Some literature defines the threshold for mystical experiecnes as a score >60
% we can compare the clustering defined threshold to this value for comparison 

% Define threshold for classifying participants
threshold_def = 0.6 * 5; 

% Classify participants based on threshold
mystical_experience = all_total_MEQ >= threshold_def;

% Visualize classification
figure;
histogram(all_total_MEQ, 'BinWidth', 0.25);
hold on;
plot([threshold_def, threshold_def], ylim, 'r--', 'LineWidth', 2);
xlabel('Overall MEQ Score');
ylabel('Frequency');
title('Classifying using defined value');
legend('Overall MEQ Scores', 'Threshold');
saveas(gcf, 'kmeans_total_MEQ_predef_threshold.png');


%% 7. Nicer visualisations! (optional) 
% Visualise plot overlayed with clusters

%Visualise histograms and scatter plots in one figure 
figure;
% Plot histogram
histogram(all_total_MEQ, 'NumBins', 15, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none'); % Pale grey bars
hold on;
plot([threshold_kmeans, threshold_kmeans], ylim, 'r--', 'LineWidth', 2)

% Scatter plot on top of histogram
jittered_y = 0.5 + rand(size(all_total_MEQ)); % Small jitter for visibility
scatter(all_total_MEQ, jittered_y, 50, idx, 'filled'); % Scatter plot coloured by cluster
plot(centroids, [1, 1], 'kx', 'MarkerSize', 15, 'LineWidth', 3); % Plot centroids

% Formatting
xlabel('Overall Total MEQ-30 Score', 'FontSize', 14);
ylabel('Frequency', 'FontSize', 14);
title('K-means Clustering of Total MEQ-30 Score', 'FontSize', 14);
legend({'Total MEQ-30 Scores Histogram', 'Threshold', 'Clustered Data Points', 'Centroids'}, 'Location', 'NorthWest');

%set(gca, 'FontSize', 14); % Adjust the font size for axes labels and tick labels
% After plotting, increase font size for all relevant components
set(gca, 'FontSize', 12); % Adjust tick labels font size

% Save the figure
saveas(gcf, 'kmeans_Total_MEQ_histogram_overlay.png');

% Add grid for better visualization
grid on;

