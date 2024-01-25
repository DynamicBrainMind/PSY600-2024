# Seed to voxel functional connectivity analysis

The function _run_seedtovoxel_GLM_ uses functions from FSL to performed seed-to-voxel functional connectivity analysis. Before using this function, you should preprocess your fMRI data using [this code](https://github.com/DynamicBrainMind/PSY600-2024/tree/main/fMRI_preproc), as the function is compatible with those outputs. You should also choose/define a region of interest in MNI152-2mm space (for example, from a functional brain atlas). The function takes in the following input arguments (all 5 required):

1. Full path to bids folder
2. Subject name
3. Full path to ROI file in MNI152-2mm space to extract and used for seed-to-voxel analysis (without .nii/.nii.gz suffix)
4. Name of preprocessed fMRI data file (must be located within derivatives/<sub>/func)
5. Output path name (set by the user) -- you may want to label this to indicate which ROI was used which preprocessing method was used (e.g. "PCC_GSR")

Outputs will be in the "analysis" folder parallel to your bids folder.

In summary, the function performs the following operations:

1) Loads the FSL module from Neurodesk
2) Registers a region of interest, defined in MNI152-2mm space, to an individual's fMRI data (using FSL's flirt function and the transform created during preprocessing).
3) Computes the mean voxel time series from the seed region (using fslmeants)
4) Sets up a general linear model (GLM) using FSL's FEAT, with the seed time course as a regressor
5) Runs the GLM to produce a voxelwise map of positive and negative associations with the seed time course
