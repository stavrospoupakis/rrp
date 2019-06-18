# RRP
Stata code for Re-scaled Regression Prediction (RRP) 

### Recent Updates
- version 0.2 18 June 2019
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
The command requires the user to first run the first-stage regression in the dataset that contains the dependent variable and the proxies, and store it. For example:

```
reg y1 z1
est store stage1
```

Then, in the other dataset, the user may run `rrp`, keeping the order of the proxies the same as in the first stage. The command returns the output of the regression table with the corrected Standard Errors, and creates the RRP imputed dependent variable, named `yhatRRP`. For example:

```
rrp x2 , proxies(z2) first(stage1)
```


### References
Crossley, T.F., Levell, P., and Poupakis, S. (2019). Regression with an Imputed Dependent Variable, Working Paper.
