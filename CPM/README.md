# Demo: Connectome-based Predictive Modeling (CPM)

These Matlab functions are slightly modified from those [at this page](https://github.com/DynamicBrainMind/CPM_CONN) for the purposes of our demo, where we will predict age from whole-brain functional connectivity using resting-state fMRI data from the [Brain Genomics Superstruct Project](https://www.nature.com/articles/sdata201531) and the [MPI-Leipzig Mind-Brain-Body dataset](https://www.nature.com/articles/sdata2018308) .

**Functions**

_CPM_internal.m_: This function performs CPM within a dataset for "internal validation." Cross-validation can be performed with leave-one-out or kfold schemes. Required inputs are (1) a 3D (ROI x ROI x subjects) variable containing functional connectivity matrices; (2) a single vector (column) containing behavioral/phenotype scores; (3) full path to output directory. Type "_help CPM_internal_" for further instructions on usage. Note: you should not interpret the p value obtained obtained from this function. To obtain an interpretable p value, you should run a permutation test during your internal validation, for example using _CPM_internal_permute.m_ at [this page](https://github.com/DynamicBrainMind/CPM_CONN). The permutation test can take a while, and so we are skipping it for the purposes of our demo.

_CPM_external.m_: After you create a CPM using internal validation, you can use CPM_external to test generalizability in an independent dataset. This requires at least 3 inputs: (1) a 3D (ROI x ROI x subjects) variable containing functional connectivity matrices from in the external dataset; (2) a single vector (column) containing behavioral/phenotype scores in the external dataset; (3) a "cpm" structure obtained from _CPM_internal.m_ with _train_mode_ set to 1. Type "_help CPM_external_" for further instructions on usage.

_CPM_view_networks.m_: If you are using certain atlases for CPM (e.g. Schaefer 300-region atlas), this function can be used to display which edges (region pairs) contributed to your CPM as function of network identity. Type "_help CPM_view_networks_" for further instructions on usage.
