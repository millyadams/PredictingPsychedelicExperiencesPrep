%Create time series matrices per dataset and calculate mean and SD for z-scoring 
clear all; 
DATADIR = '/Volumes/Harddrive/Project_Data';
cd(DATADIR)

filelist = {dir("*.mat").name};
filelist = filelist(~contains(filelist, '._'));

CI_timeSeriesData = [];
Imaging_timeSeriesData = [];
Pilot_timeSeriesData = [];

%loop through files
for i = 1:length(filelist)                  %for all files in list 
    filename = filelist{i};                 %select next file 
    filepath = fullfile(DATADIR, filename); %create file path from datadirectory and file name
    file_data = load(filepath);                     % load data 

    %matrix to store current file data
    current_data = [];
    for j = 1:length(file_data.data.trial)  
        current_data = [current_data; file_data.data.trial{j}];
    end

    %separate datasets based on name and concatanate 
    if startsWith(filename, 'CI_')
        CI_timeSeriesData = [CI_timeSeriesData; current_data];
    elseif startsWith(filename, 'Imaging_')
        Imaging_timeSeriesData = [Imaging_timeSeriesData; current_data];
    elseif startsWith(filename, 'Pilot')
        Pilot_timeSeriesData = [Pilot_timeSeriesData; current_data];
    end
end

%Find mean and SD across trial data within subdatasets 
%timeSeriesData = matrix with all time series for all ppts 
CI_mean = mean(CI_timeSeriesData(:));
CI_sd = std(CI_timeSeriesData(:));

Imaging_mean = mean(Imaging_timeSeriesData(:));
Imaging_sd = std(Imaging_timeSeriesData(:));

Pilot_mean = mean(Pilot_timeSeriesData(:));
Pilot_sd = std(Pilot_timeSeriesData(:));

disp(['CI mean: ' num2str(CI_mean)]);
disp(['CI SD:', num2str(CI_sd)])

disp(['Imaging mean: ' num2str(Imaging_mean)]);
disp(['Imaging SD:', num2str(Imaging_sd)])

disp(['Pilot mean: ' num2str(Pilot_mean)]);
disp(['Pilot SD:', num2str(Pilot_sd)])

save('mean_sd.mat', 'CI_mean', 'CI_sd', 'Imaging_mean', 'Imaging_sd', 'Pilot_mean', 'Pilot_sd');
