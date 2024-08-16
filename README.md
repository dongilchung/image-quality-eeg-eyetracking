# image-quality-eeg-eyetracking
This repository contains the data and analysis scripts used for our study on EEG and eye-tracking metrics, including saccades, blinks, and pupil size dynamics. This dataset and the associated scripts provide a comprehensive foundation for replicating our statistical analyses and generating the figures presented in the publication.

## Repository Structure and Detailed Contents
The repository is organized into three main folders: 0_data/, 1_figure/, and 2_analysis/. Below is a detailed description of the contents in each folder, including the scripts used for data processing, analysis, and figure generation.

### Folder ```1_data```:
This folder contains the raw and pre-processed data files, including EEG, eye-tracking, and behavioral data.
- ```Behavior_vivid.mat```: This is behavior data for vividness block.
- ```Behavior_valence.mat```: This is behavior data for valence block.
- ```Behavior_arousal.mat```: This is behavior data for arousal block.
- ```Ch.brain.mat```: Numbering of 32 channel actiCAP EEG-System. Used to draw the graph of 31 channels of EEG information.
- ```Ancova_used_data.mat```: Contains data on pupil size and its temporal dynamics.
- ```Chan_hood_5cm.mat```: Data for cluster-based permutation test. Clustering channels when the adjacent channel is located within 5cm on the scalp. Created by Anal_Create_Chanhood.m
- ```metricTab3_4.mat```: This pre-processed data file contains extracted eye metrics, including saccade, blink, and pupil size.
- ```pupilTab.mat```: Contains data on pupil size and its temporal dynamics.
- ```evTab_4_all_tasks.csv```: This file is organized for ANCOVA analysis in R.
### Folder ```2_analysis```:
This folder is divided into three sections: Pre-processing, Data Analysis, and Statistical Analysis in R.
#### Pre-processing:
- ```Anal_eeg_Create_chanhood.m```: Create EEG clustering channel information before launching cluster-based permutation analysis.
- ```Anal_eeg_Ancova_data_load_for_R_analysis.m```: Extracts data set for 1000 times of ANCOVA random sampled analysis.
- ```Anal_eye_2_preprocessing.m```: Parses trial information from experiments.
- ```Anal_eye_3_3_eye_metric_rev3.m```: Extracts eye metrics from raw data.
- ```Anal_eye_4_3_gen_table_for_anova.m```: Generates tabular data for running ANCOVA in R.
- ```Anal_eye_6_1_gen_anova_tab_pupil_time.m```: Prepares data of temporal pupil size for ANCOVA.
#### Data Analysis:
- ```Anal_eeg_Multiple_Linear_Regression_image_based.m```: Multiple linear regression analysis between EEG responses and the subjective ratings. 'Image_based' means that 3(white-boost modes) x 2(color-gamut) x 2(repetitions) = 12(One IAPS image with 12 trials) 
- ```Anal_eeg_Residual_Multiple_Linear_Regression_image_based.m```: Residual Multiple linear regression analysis between EEG responses and the subjective ratings.
- ```Anal_eeg_cluster_based_permutation.m```: Cluster based permutation test of ANCOVA statistics and multiple linear regression, residual linear regression betas.
- ```Anal_eeg_Ancova_figure_analysis.m```: Loads Ancova statistics and analyzes ANCOVA statistics including cluster-based permutation analysis and topographical analysis.
- ```Anal_eye_5_42_rating_lin_reg.m```: Analyzes the correlation between eye metrics and vividness ratings.
- ```Anal_eye_6_3_rating_lin_reg_pupil_time.m```: Examines the correlation between pupil size and vividness ratings over time.
- ```Anal_eye_7_2_1_residual_linear_reg_suppl.m```: Analyzes residual regression between eye metrics and vividness ratings.
- ```Anal_eye_7_3_1_residual_linear_reg_puptime_suppl.m```: Analyzes residual regression for temporal pupil size data.
#### Statistical Analysis in R:
- ```Anal_eeg_ANCOVA_1000times_random_sampled.R```: Runs cluster-based permutation ANCOVA for EEG.
- ```Anal_eye_ANCOVA_pupilTime_permu2.R```: Runs cluster-based permutation ANCOVA.
- ```Anal_eye_ANCOVA_eye_metrics.R```: Performs ANCOVA on eye metrics data.
- ```Anal_eye_ANCOVA_pupilTime.R```: Conducts ANCOVA on temporal pupil size data.
- ```Anal_eye_ANCOVA_pupilTime_posthoc.R```: Executes post-hoc tests following ANCOVA.
### Folder ```3_figure```:
This folder contains scripts for generating figures presented in the paper.
- **Figure 2(b)**: This code generates figure 2(b), about self-reports on the subjective vividness rating.  
- **Figure 4**: This code generates figure 4(a): Distinct EEG-patterns in response to three White-boosting modes, This figure contents involves cluster-based permutation analysis. This statistical analysis needs to load data by using Anal_Ancova_data_load_for_R_analysis.m and 1000times of ANCOVA analysis from R by using Anal_Ancova_1000times_random_sampled.R. Finally, Anal_cluster_based_permutation.m and Ancova_figure_analysis.m is used to present significant clusters in Figure 4(a). Figure 4(b): Topographical representation of F statistics across 31 EEG channels
- **Figure 5(a-c)**: Generated using the script Anal_5_31_5_wb_ANCOVA.m.
- **Figure 5(d)**: Generated from the script Anal_6_2_1_pupil_time_wb_plot.m.
- **Figure 6(a-c)**: This code generates figure 6a: Three distinct ERP of vividness rating groups (dull,mid and vivid), figure 6b: Multiple linear regression analysis of ERP and subjective rating by using Anal_Multiple_Linear_Regression_image_based.m, figure 6c: Topographical representation of t-statistics across 31 EEG channels.
- **Figure 7(a-d)**: Created using the script Anal_5_42_rating_lin_reg_plot.m.
- **Figure 7(e-f)**: Produced from Anal_6_3_rating_lin_reg_pupil_time_plot.m.
#### Supplementary Figures:
- **Figure S1**: Self-reports on image-associated valence and arousal.
- **Figure S2**: Objective White-boosting modes manifest in distinct EEG responses: 
ERPs and F-values across all 31 channels. 
- **Figure S3**: Impacts of image-associated arousal and valence on EEG responses. This figure refers Anal_Ancova_figure_analysis.
- **Figure S4**: Generated with Anal_5_31_5_wb_ANCOVA.m.
- **Figure S5**: Created using Anal_7_1_coeff_plot_suppl.m.
- **Figure S6**: Vividness ratings manifest in distinct EEG responses: beta estimates 
for image-associated vividness rating (β1) across all 31 channels. Figure S6a refers Anal_Multiple_Linear_Regression_image_based.m and Figure S6b refers Anal_cluster_based_permutation.m
- **Figure S7**: Residual regression analysis: the association between EEG responses 
and the vividness ratings remains robust after controlling for the variance captured 
by image-associated arousal and valence. This figure is produced by Anal_Residual_Multiple_Linear_regression_image_based.m and Anal_cluster_based_permutation.m
- **Figure S8**: Produced from Anal_7_2_2_residual_linear_reg_suppl_plot.m.
