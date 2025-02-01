function [LZc_output] = kate_LZc(data_trialscut)

datamat = fieldtrip2mat_epochs(data_trialscut); %Turn into matrix format

for jj = 1:size(datamat,1) %Loop through chans
    fprintf('LZs computation Channel %d .....', jj) ;
    sig = squeeze(datamat(jj,:,:));
        for ii=1:size(sig,2) % loop through each trial
            data = sig(:,ii)';
            LZc(jj,ii) = LZ76(data > mean(data)); %obtain the LZs value for that string
            EntropyRt(jj,ii) = LZ76(data> mean(data))*(log2(length(data))/length(data)) ;% obtain entropy rate

            % Hilbert transformed data
            data = hilbert(data);
            data = abs(data);
            LZc_hilbert(jj,ii) = LZ76(data > mean(data)); %obtain the LZs value for that string
            EntropyRt_hilbert(jj,ii) = LZ76(data> mean(data))*(log2(length(data))/length(data)) ;% obtain entropy rate
        end
     fprintf('..completed \n');
end

LZc_output.LZc =  mean(LZc(:,:),2);
LZc_output.EntropyRt =  mean(EntropyRt(:,:),2);
LZc_output.LZc_hilbert =  mean(LZc_hilbert(:,:),2); 
LZc_output.EntropyRt_hilbert =  mean(EntropyRt_hilbert(:,:),2); 




