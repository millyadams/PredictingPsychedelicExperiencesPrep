# EEG Feature Extraction 

## Preparation / data 

1. Processing 
- Ensure your data has been preprocessed. If you are using multiple datasets, these should be harmonised using consistent sampling rates and epoching. 
- If you are using multiple EEG caps, ensure electrodes are mapped to a consistent 32-channel space. For high-density EEG to 10-20 mapping please see [Luu & Ferree (2005](https://www.researchgate.net/publication/266609828_Determination_of_the_Geodesic_Sensor_Nets'_Average_Electrode_Positions_and_Their_10_-_10_International_Equivalents).

2. Normalisation
- If you aim to extract absolute power and LZ features ensure you have z-scored your dataset
- For relative power extraction use the non-normalised dataset 

## Scripts should be run in the following order: 

### 1. (Optional) Dataset normalisation
   - Normalisation_av_sd.m
   - Z-scoring.m

### 2. Feature extraction 
  - FeatureExtraction_AbsPower_LZ.m
  - FeatureExtraction_RelPower.m

### 3. Ensuring python compatability 
  - Features_to_CSV.m
  - MappingClassifications 
