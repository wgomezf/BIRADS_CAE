# `Convolutional autoencoder-based feature extractor for BI-RADS classification`

<p align="center">
  <img src="https://github.com/wgomezf/BIRADS_CAE/blob/main/images/model.png" width="600">
</p>

The source code for a convolutional autoencoder (CAE)-based feature extractor is provided for classifying breast tumors in ultrasound (BUS) images into BI-RADS categories 2-5. The model utilizes a convolutional neural network (CNN) for BI-RADS classification, taking encoder feature maps at multiple levels of abstraction as input. Both the CAE and CNN parameters are learned simultaneously via a loss function that combines mean squared error (to minimize image reconstruction error) and categorical cross-entropy (to minimize BI-RADS classification error).

## `Source code`

The code was written in MATLAB 2025b, and two folders containing the following programs are provided:
*   [`k-folds:`](https://github.com/wgomezf/BIRADS_CAE/tree/main/Codes/k-folds) Perform $k$-fold cross-validation experiments for model training and evaluation.
*   [`reproduce:`](https://github.com/wgomezf/BIRADS_CAE/tree/main/Codes/reproduce) The 5-fold cross-validation experiments reported in the article are reproduced.

The input image for the models is the ROI$_{m}^{p}$ configuration, which masks the tumor region while preserving its aspect ratio by adding zero-padding.

## `Reference`

W. Gómez-Flores and W. C. A. Pereira, "BI-RADS Classification of Breast Tumors in Ultrasound Using Convolutional Autoencoder-Based Feature Extractor", in Proceedings of the 2026 Global Medical Engineering Physics Exchanges/ Pan American Health Care Exchanges (GMEPE/PAHCE), Rio de Janeiro, Brazil, April 6-10, 2026, pp. 1-6. DOI: Pending 
