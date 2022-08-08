# RRP
Stata code for Re-scaled Regression Prediction (RRP) 

### Install
This is a development version, to download it and use, open Stata and run the following:

```
cap ado uninstall rrp
net install rrp, from("https://raw.githubusercontent.com/spoupakis/rrp/master/")
```

### Description
This repository contains the Stata package implementing the Rescaled Regression Prediction (RRP) using two samples in two steps, as described in Crossley et al. (2022). 

#### Syntax
The command requires the user to first run the first-stage regression in the dataset that contains the dependent variable and the proxies, and store the estimation. Note that the user also needs to provide the partial R-squared. Although many ways exist to implement this, we provide below what we think is an easy way to derive it:

```
reg  y w
scalar R2_A = e(r2)
reg y zA zB w
est store stage1
scalar R2_B = e(r2)
scalar Rsq = (R2_B-R2_A)/(1-R2_A)
```

Then, in the other dataset, the user may run `rrp`, making sure the proxies have the same name as in the first stage. The command returns the output of the regression table with the corrected Standard Errors and creates the RRP imputed dependent variable.

```
rrp x w , impute(yhat) proxies(zA zB) partialrsq(Rsq) first(stage1) 
```


### References
Crossley, T.F., Levell, P., and Poupakis, S. (2022). Regression with an Imputed Dependent Variable, *Journal of Applied Econometrics* https://doi.org/10.1002/jae.2921

