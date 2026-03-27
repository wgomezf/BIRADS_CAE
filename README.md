# `Convolutional autoencoder-based feature extractor for BI-RADS classification`

<p align="center">
  <img src="https://github.com/wgomezf/BIRADS_CAE/blob/main/images/model.png" width="400">
</p>

The source code for a convolutional autoencoder (CAE)-based feature extractor is provided for classifying breast tumors in ultrasound (BUS) images into BI-RADS categories 2-5. The model utilizes a convolutional neural network (CNN) for BI-RADS classification, taking encoder feature maps at multiple levels of abstraction as input. Both the CAE and CNN parameters are learned simultaneously via a loss function that combines mean squared error (to minimize image reconstruction error) and categorical cross-entropy (to minimize BI-RADS classification error).

Any use of our CNN models, please cite:

Wilfrido Gomez-Flores and Wagner Coelho de Albuquerque Pereira, "BI-RADS Classification of Breast Tumors in Ultrasound Using Convolutional Autoencoder-Based Feature Extractor", in Proceedings of the 2026 Global Medical Engineering Physics Exchanges/ Pan American Health Care Exchanges (GMEPE/PAHCE), Rio de Janeiro, Brazil, April 6-10, 2026, pp. 1-6. DOI: Pending 
