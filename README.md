# RRP
Stata code for Re-scaled Regression Prediction (RRP) 

### Recent Updates
- version 0.4 10 Dec 2019
  - proxy variables need to have the same name (order does not matter); added partial R-squared option;
- version 0.3 31 Oct 2019
  - added robust/cluster se option; imputed variable name option; improved printed output
- version 0.2 18 Jun 2019
  - update for unequal sample sizes
- version 0.1 26 Feb 2019
  - First Version

### Install
This is a development version, to download it and use, open Stata and run the following:

```
cap ado uninstall rrp
net install rrp, from("https://raw.githubusercontent.com/spoupakis/rrp/master/")
```

### Description
This repository contains the Stata package implementing the Rescaled Regression Prediction (RRP) using two samples in two steps, as described in Crossley et al. (2019). 

#### Syntax
The command requires the user to first run the first-stage regression in the dataset that contains the dependent variable and the proxies, and store the estimation. Note that the user also needs to provide the partial R-squared, thus the following steps need to be followed:

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
Crossley, T.F., Levell, P., and Poupakis, S. (2019). Regression with an Imputed Dependent Variable, [IFS Working Paper W19/16](https://www.ifs.org.uk/publications/14165).

