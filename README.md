# image-quality-eeg-eyetracking

This repository contains the data and analysis scripts used for our study on eye-tracking metrics, including saccades, blinks, and pupil size dynamics. The data is meticulously organized and processed to facilitate various statistical analyses and visualizations. Below, you will find a detailed description of the contents in each folder, including the scripts used for data processing, analysis, and figure generation.

## Folder Structure and Contents
### Folder ```0_data```:
- ```metricTab3_4.mat```: This pre-processed data file contains extracted eye metrics, including saccade, blink, and pupil size.
- ```pupilTab.mat```: Contains data on pupil size and its temporal dynamics.
- ```evTab_4_all_tasks.csv```: This file is organized for ANCOVA analysis in R.
### Folder ```1_figure```:
- **Figure 5(a-c)**: Generated using the script Anal_5_31_5_wb_ANCOVA.m.
- **Figure 5(d)**: Generated from the script Anal_6_2_1_pupil_time_wb_plot.m.
- **Figure 7(a-d)**: Created using the script Anal_5_42_rating_lin_reg_plot.m.
- **Figure 7(e-f)**: Produced from Anal_6_3_rating_lin_reg_pupil_time_plot.m.
#### Supplementary Figures:
- **Figure S4**: Generated with Anal_5_31_5_wb_ANCOVA.m.
- **Figure S5**: Created using Anal_7_1_coeff_plot_suppl.m.
- **Figure S8**: Produced from Anal_7_2_2_residual_linear_reg_suppl_plot.m.
### Folder ```2_analysis```:
#### Pre-processing:
- ```Anal_2_preprocessing.m```: Parses trial information from experiments.
- ```Anal_3_3_eye_metric_rev3.m```: Extracts eye metrics from raw data.
- ```Anal_4_3_gen_table_for_anova.m```: Generates tabular data for running ANCOVA in R.
- ```Anal_6_1_gen_anova_tab_pupil_time.m```: Prepares data of temporal pupil size for ANCOVA.
#### Data Analysis:
- ```Anal_5_42_rating_lin_reg.m```: Analyzes the correlation between eye metrics and vividness ratings.
- ```Anal_6_3_rating_lin_reg_pupil_time.m```: Examines the correlation between pupil size and vividness ratings over time.
- ```Anal_7_2_1_residual_linear_reg_suppl.m```: Analyzes residual regression between eye metrics and vividness ratings.
- ```Anal_7_3_1_residual_linear_reg_puptime_suppl.m```: Analyzes residual regression for temporal pupil size data.
#### Statistical Analysis in R:
- ```Anal_ANCOVA_pupilTime_permu2.R```: Runs cluster-based permutation ANCOVA.
- ```Anal_ANOVA_eye_metrics.R```: Performs ANCOVA on eye metrics data.
- ```Anal_ANOVA_pupilTime.R```: Conducts ANCOVA on temporal pupil size data.
- ```Anal_ANOVA_pupilTime_posthoc.R```: Executes post-hoc tests following ANCOVA.
