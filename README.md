# image-quality-eeg-eyetracking
This repository contains codes of figure generation and statistical analysis such as multiple linear regression and cluster-based permutation.
## Folder Structure and Contents
### Folder ```0_data```:
- ```Ch.brain.mat```: Numbering of 32 channel actiCAP EEG-System. Used to draw the graph of 31 channels of EEG information.
- ```Ancova_used_data.mat```: Contains data on pupil size and its temporal dynamics.
- ```Chan_hood_5cm.mat```: Data for cluster-based permutation test. Clustering channels when the adjacent channel is located within 5cm on the scalp. Created by Anal_Create_Chanhood.m
- ```Behavior_vivid.mat```: This is behavior data for vividness block.
- ```Behavior_valence.mat```: This is behavior data for valence block.
- ```Behavior_arousal.mat```: This is behavior data for arousal block.
- ### Folder ```1_figure```:
- **Figure 2B**: This code generates figure 2B, about self-reports on the subjective vividness rating.  
- **Figure 4**: This code generates figure 4a: Distinct EEG-patterns in response to three White-boosting modes, This figure contents involves cluster-based permutation analysis. This statistical analysis needs to load data by using Anal_Ancova_data_load_for_R_analysis.m and 1000times of ANCOVA analysis from R by using Anal_Ancova_1000times_random_sampled.R. Finally, Anal_cluster_based_permutation.m and Ancova_figure_analysis.m is used to present significant clusters in Figure 4a. 
                - figure 4b:Topographical representation of F statistics across 31 EEG channels
- **Figure 6(a-c)**: This code generates figure 6a: Three distinct ERP of vividness rating groups (dull,mid and vivid), figure 6b: Multiple linear regression analysis of ERP and subjective rating by using Anal_Multiple_Linear_Regression_image_based.m, figure 6c: Topographical representation of t-statistics across 31 EEG channels.
#### Supplementary Figures:
- **Figure S1**: Self-reports on image-associated valence and arousal.
- **Figure S2**: Objective White-boosting modes manifest in distinct EEG responses: 
ERPs and F-values across all 31 channels. 
- **Figure S3**: Impacts of image-associated arousal and valence on EEG responses. This figure refers Anal_Ancova_figure_analysis.
- **Figure S6**: Vividness ratings manifest in distinct EEG responses: beta estimates 
for image-associated vividness rating (β1) across all 31 channels. Figure S6a refers Anal_Multiple_Linear_Regression_image_based.m and Figure S6b refers Anal_cluster_based_permutation.m
- **Figure S7**: Residual regression analysis: the association between EEG responses 
and the vividness ratings remains robust after controlling for the variance captured 
by image-associated arousal and valence. This figure is produced by Anal_Residual_Multiple_Linear_regression_image_based.m and Anal_cluster_based_permutation.m
### Folder ```2_analysis```:
#### Pre-processing:
- ```Anal_Create_chanhood.m```: Create EEG clustering channel information before launching cluster-based permutation analysis.
- ```Anal_Ancova_data_load_for_R_analysis.m```: Extracts data set for 1000 times of ANCOVA random sampled analysis.
#### Data Analysis:
- ```Anal_Multiple_Linear_Regression_image_based.m```: Multiple linear regression analysis between EEG responses and the subjective ratings. 'Image_based' means that 3(white-boost modes) x 2(color-gamut) x 2(repetitions) = 12(One IAPS image with 12 trials) 
- ```Anal_Residual_Multiple_Linear_Regression_image_based.m```: Residual Multiple linear regression analysis between EEG responses and the subjective ratings.
- ```Anal_cluster_based_permutation.m```: Cluster based permutation test of ANCOVA statistics and multiple linear regression, residual linear regression betas.
- ```Anal_Ancova_figure_analysis.m```: Loads Ancova statistics and analyzes ANCOVA statistics including cluster-based permutation analysis and topographical analysis.
#### Statistical Analysis in R:
- ```Anal_ANCOVA_1000times_random_sampled.R```: Runs cluster-based permutation ANCOVA for EEG.
