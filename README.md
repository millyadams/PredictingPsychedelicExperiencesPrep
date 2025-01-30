# PredictingPsychedelicExperiencesPrep

# PredictingPschedelicExperiences
## Investigating EEG Predictors of the Acute DMT Experience
This repository contains code preparing EEG data (input features) and generating groups of subjective experiences (labelled outcomes) prior to machine learning. The project goal is to  
investigate whether features of participants' baseline, resting-state EEG signals can be used to predict binarised classifications of subsequent DMT experiences (e.g., Mystical vs Non-Mystical). 

For subsequent machine learning see the [PredictingPschedelicExperiencesPrep](https://github.com/millyadams/PredictingPschedelicExperiences)repository. 

To run this code, you will need to install MATLAB_R2024b. 

## Datasets 
The pipeline uses EEG and subjective experience data from 50 healthy control (HC) participants across three studies collected by the Centre for Pyschedelic Research at Imperial College London: [Timmerman et al., 2019](https://www.nature.com/articles/s41598-019-51974-4), [Timmerman et al., 2023](https://www.pnas.org/doi/10.1073/pnas.2218949120), [Luan et al., 2024](https://journals.sagepub.com/doi/10.1177/02698811231196877). 

### EEG Data
EEG features are extracted from resting-state EEG recordings collected immediately prior to DMT intraveneous infusion.
### Subjective Experience Data 
Three experience classifications are used as binary outcome labels: Mystical, Visual and Anxious. 

## Pipeline 
### Preprocessing + dataset harmonisation (code not included) 
### Generating experience labels 
Binary experience labels for each participants were assigned for three discrete categories: Mystical, Visual and Anxious. 
Experience labels were generated using unsupervised clustering with two centroids and one dimension, defined as the relevant continuous questionnaire score. 

### Extracting EEG features 
We wanted to compare whether absolute or relative power features extracted from EEG data had higher predictive power.

1. Normalised EEG data by z-scoring to dataset-specific mean and SD
2. Extracted Absolute Power and Lempil Ziv Complexity from normalised data
3. Extracted Relative Power from non-normalised data
4. Concatanated with output labels into single dataframe and converted to .csv for use in python

The result of running these scripts is a dataframe with 448 features and 3 binary labels for each sample in .mat and .csv formats. 
