### Mimnagh et al.,   "A Bayesian Model to Estimate Abundance Based on Scarce Animal Vestige Data"
https://doi.org/10.48550/arXiv.2206.05944

### R Files
triple_poisson.R contains code to simulate data for the triple Poisson model, fits the model with both Poisson and negative binomial distributions on the observed vestige counts and compares the two models using DIC values as was performed for the case studies.

triple_poisson_simulation.R contains functions which were used to carry out simulation studies, and calculate the mean relative bias in the estimates.

### Datasets

The sika deer dataset (Marques et al., 2001) is available as part of the Distance R package (Miller et al., 2019).

The red deer dataset is provided in full in the original 1994 paper by Cavallini.

The collared peccary data is provided in full in Section 4.1 of this paper.

The kit fox data is available as supplementary material in Dempsey et al., 2014.

### References:
Cavallini, Paolo (1994). “Faeces count as an index of fox abundance”. In: Acta theriologica 39.4, pp. 417–424.

Dempsey, Steven J. et al. (2014). “Finding a fox: an evaluation of survey methods to estimate abundance of a small desert carnivore”. In: PloS one 9.8, e105873

Marques, Fernanda F. C. et al. (2001). “Estimating deer abundance from line transect surveys of dung: sika deer in southern Scotland”. In: Journal of Applied Ecology, pp. 349–363.

Miller, David L. et al. (2019). “Distance Sampling in R”. In: Journal of Statistical Software 89.1, pp. 1–28. doi:10.18637/jss.v089.i01. url: https://www.jstatsoft.org/index.php/jss/article/view/v089i01.
