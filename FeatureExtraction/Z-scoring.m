%Z-Score based on mean and SD calculated in other script 
%Saved and can be loaded
clear all 
load('/Volumes/Harddrive/Normalise/mean_sd.mat'); %load saved mean and sd values 

DATADIR = '/Volumes/Harddrive/Project_Data/';
SAVEDIR = '/Volumes/Harddrive/Project_Data_Normalised';

cd(DATADIR)

filelist = {dir("*.mat").name};                     % List all .mat files and create cell array of file names 
filelist = filelist(~contains(filelist, '._'));     % Excludes hidden files 

for i = 1:length(filelist)                      %for all files                   
    filepath = fullfile(DATADIR, filelist{i});  %construct path
    load(filepath);
    filename = filelist{i};

    %Select mean and sd to normalise 
    if startsWith(filename, 'CI_')
        dataset_mean = CI_mean;
        dataset_sd = CI_sd;
        
    elseif startsWith(filename, 'Imaging_')
        dataset_mean = Imaging_mean;
        dataset_sd = Imaging_sd;
    
    elseif startsWith(filename, 'Pilot_')
        dataset_mean = Pilot_mean;
        dataset_sd = Pilot_sd;
    end
    %Normalise each trial 
    for j = 1:numel(data.trial)
        % Calculate z-score for each trial
        data.trial{j} = (data.trial{j} - dataset_mean) ./ dataset_sd;
    end
    save(fullfile(SAVEDIR, filelist{i}), 'data'); 
end
