# fMRI Preprocessing Demo
This repository contains code for preprocessing of raw fMRI data for single fMRI run in one subject, assuming fMRI and T1 data are organized in BIDS format. The function _all_preproc_GSR_ does the following steps: (1) segments the T1 scan into white matter, gray matter and cerebrospinal fluid (using FSL's FAST function); (2) uses FSL's FEAT tool to perform fMRI motion correction, brain extraction, and fMRI-T1-MNI registration; (3) regresses out the global signal and mean signals from thresholded versions of the white matter and cerebrospinal fluid masks estimated by FAST; (4) performs spatial smoothing (using a 6mm kernel); (5) performs bandpass temporal filtering between 0.01 - 0.1 Hz; (6) transforms data to MNI152-2mm space.

**Setup**
The _all_preproc_GSR_ function is compatible with Neurodesktop, which can be installed [here](https://www.neurodesk.org/docs/getting-started/neurodesktop/). The function uses commands from FSL, AFNI, and Python. It automatically launches FSL and AFNI from Neurodesktop.

To make sure that you can run the _all_preproc_GSR_ function from any terminal (from any location), you should do the following:

1. In the terminal, cd to the PSY600-2024 folder and type _chmod -R 777_fMRI_preproc._ This will set permissions to make commands executable.
  
2. Edit your .bashrc file to make the functions executable from any location within the terminal. The .bashrc file is a 'hidden' text file in your home directory that can be edited. Within a Neurodesktop terminal, cd to your home directory (e.g. /home/jovyan) and type _gedit _.bashrc_. A text editor will open with the contents of _.bashrc_. At the bottom of the file, add this line and then save (assuming the location below is where you saved/cloned this code):
_PATH="/home/jovyan/neurodesktop-storage/code/PSY600-2024/fMRI_preproc:${PATH}"_
