# Demo: Dynamic functional connectivity

These functions demonstrate sliding-window functional connectivity analysis, including extracting connectivity matrices across windows and applying kmeans clustering to detect recurring functional connectivity patterns.

This repository contains two functions, one in bash (to be run in Neurodesktop) and one in Matlab. After you pull from github, add this "dynamic_FC" path to your .bashrc file in Neurodesktop (as described in Setup [here](https://github.com/DynamicBrainMind/PSY600-2024/tree/main/fMRI_preproc)). To run the Matlab function, add this folder to your path within Matlab or run this from within the folder.

**Functions**

1. _extract_ts_atlas_: This bash functions uses FSL's _fslmeants_ function to extract preprocessed BOLD time series from all regions in an atlas in MNI152-2mm space. It assumes that you have used [_all_preproc_GSR_](https://github.com/DynamicBrainMind/PSY600-2024/blob/main/fMRI_preproc/all_preproc_GSR) for preprocessing. In the demo, we will be extracting BOLD time series from the Schaefer 100-region atlas, as the subsequent sliding window analyses is set up for using that atlas as input.

2. _SWC_kmeans_Schaefer100.m_: This matlab function loads in the BOLD time series (as obtained from extract_ts_atlas), computes sliding-window correlations between 64 of the regions (limited to the default mode, dorsal attention, frontoparietal control, and salience network), performs kmeans clustering, and displays the cluster centroid patterns as well as the static functional connectivity matrix for comparison. Requires inputs are k (number of clusters) and window length (in seconds).

