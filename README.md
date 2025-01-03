## A Bayesian Model to Estimate Abundance Based on Scarce Animal Vestige Data


This study presents a Bayesian model designed to estimate animal abundance from limited or scarce data on vestiges, such as faeces counts or other indirect indicators of presence. The approach is particularly useful in situations where direct observations of animals are challenging or impractical. The paper compares the performance of the Bayesian model using both Poisson and negative binomial distributions to describe observed counts and evaluates their performance using Deviance Information Criterion (DIC) values.


### Supplementary R Files

* triple_poisson.R: This script contains code to simulate data for the triple Poisson model. It fits the model to the simulated data using both Poisson and negative binomial distributions for the observed vestige counts. Additionally, it compares the two model specifications using DIC values, replicating the analyses performed in the case studies presented in the paper.

* triple_poisson_simulation.R: This file includes functions used to conduct simulation studies that assess the performance of the model. The functions calculate the mean relative bias in abundance estimates, enabling a quantitative evaluation of the model’s accuracy and reliability under different scenarios.



### Datasets

The study utilises datasets from real-world case studies to demonstrate the application of the model:

* Sika Deer Dataset: Originally described by Marques et al. (2001), this dataset estimates deer abundance from line transect surveys of dung in southern Scotland. The data is available through the Distance R package (Miller et al., 2019).

* Red Deer Dataset: Published in its entirety by Cavallini (1994), this dataset is based on faeces counts used as an index of red fox abundance. The original data is drawn from a detailed study in Acta Theriologica.

* Collared Peccary Dataset: This dataset is presented in full within Section 4.1 of the Mimnagh et al. paper, providing another case study example of the model’s utility.

### Applications

This Bayesian approach to modelling animal abundance provides a robust statistical framework for addressing challenges associated with limited data availability. The ability to incorporate negative binomial distributions makes it well-suited to handle overdispersion commonly observed in ecological datasets. The paper highlights the flexibility and practical applicability of the model through its simulation studies and real-world case studies.

### References

Cavallini, Paolo (1994): "Faeces count as an index of fox abundance". Published in Acta Theriologica, Volume 39, Issue 4, pp. 417–424.

Marques, Fernanda F. C. et al. (2001): "Estimating deer abundance from line transect surveys of dung: Sika deer in southern Scotland". Published in Journal of Applied Ecology, pp. 349–363.

Miller, David L. et al. (2019): "Distance Sampling in R". Published in Journal of Statistical Software, Volume 89, Issue 1, pp. 1–28. DOI: 10.18637/jss.v089.i01.

Mimnagh, N., Ferreira, I., Verdade, L., & Moral, R. D. A. (2022). A Bayesian Model to Estimate Abundance Based on Scarce Animal Vestige Data. arXiv preprint arXiv:2206.05944.






