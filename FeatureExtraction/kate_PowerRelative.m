function [relative_power] = kate_PowerRelative(data_trialscut)
%Function declaration, returns the 'power' variable 
%Function is called 'kate_Power' 
%data_trialscut is the input passed into the function - for me this will just be data 

bands = [1 4; 4 8; 8 13; 13 20; 20 30; 30 45]; %define frequency bands
band_names = {'delta', 'theta', 'alpha', 'betaL', 'betaH', 'gamma'};

% FFT for low frequencies:
cfg             = [];
cfg.method      = 'mtmfft';     % analyses entire spectrum for the entire data length
cfg.output      = 'pow';
cfg.taper       = 'hanning';       % default = dpss
cfg.foi         = 1: 0.5: 30;    % frequency band of interest (min:stepsize:max)
cfg.keeptrials = 'no';
cfg.showcallinfo = 'no';
cfg.pad='nextpow2';
flowr = ft_freqanalysis(cfg, data_trialscut);

% FFT for high frequencies:
cfg             = [];
cfg.method      = 'mtmfft';     % analyses entire spectrum for the entire data length
cfg.output      = 'pow';
cfg.taper       = 'dpss';       % default = dpss
cfg.foilim      = [30 45];    % frequency band of interest
cfg.tapsmofrq   = 3;          % frequency smoothing
cfg.keeptrials = 'no';
fhighr = ft_freqanalysis(cfg, data_trialscut);

%Extract power within defined frequency bands 
freq = flowr.freq;

total_power = zeros(size(flowr.powspctrm, 1), 1); % Initialize total power array
    
for i = 1:5 %loop through first five bands 
    indx1 = find(abs(freq-bands(i,1)) == min(abs(freq-bands(i,1))));
    indx2 = find(abs(freq-bands(i,2)) == min(abs(freq-bands(i,2))));

    power.(band_names{i}) = mean(flowr.powspctrm(:,indx1:indx2),2);
    total_power = total_power + power.(band_names{i});
end

%for high gamma 
freq = fhighr.freq;
indx1 = find(abs(freq-bands(6,1)) == min(abs(freq-bands(6,1)))); %when calculating relative power this would be divided by mean of whole 
indx2 = find(abs(freq-bands(6,2)) == min(abs(freq-bands(6,2))));

power.(band_names{6}) = mean(fhighr.powspctrm(:,indx1:indx2),2); 
total_power = total_power + power.(band_names{6}); 
%output is the power sructure containing mean power in each frequency band, averaged across trials 

%relative power 
relative_power = struct();
for i = 1:6
    relative_power.(band_names{i}) = power.(band_names{i}) ./ total_power;
end

end 
