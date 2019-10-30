* ------------------------------------------------------------------------------
* Title  : Rescaled Regression Prediction (RRP) using two samples
* Author : Stavros Poupakis
* Email  : s.poupakis@gmail.com
* Version: 0.3 (30 October 2019)
* ------------------------------------------------------------------------------


cap program drop rrp
program define rrp, eclass                                                                                    
version 14

syntax varlist(numeric ts fv) [if] [in] [aweight pweight fweight iweight] [,IMPUTE(string) PROXIES(varlist numeric ts fv) FIRST(string) Robust Cluster(varlist)]
marksample touse

tempvar ones 
tempname sigma1 Rsq1 sigma2 Rsq2 n1 n2 Z1X XX ZX XZ ZZ beta gamma Vb Vg V F Fdf1 Fdf2 Fp proxymat

qui est restore `first'
scalar `Rsq1'   = e(r2)
scalar `sigma1' = e(rmse)
scalar `n1'     = e(N)
mat `gamma'     = e(b)
mat `Vg'        = e(V)

local names1 : colfullnames `gamma'
qui matrix accum `proxymat' =  `proxies'  if `touse'
local names2 : colfullnames `proxymat'

matrix colnames `gamma'      = `names2'
matrix score double `impute' = `gamma' if `touse'
qui replace `impute'         = `impute'/`Rsq1'

if "`robust'" != "" {
	qui reg `impute' `varlist'  if `touse', robust
	mat `Vb'   = e(V)
	local vce                   "robust"
	local vcetype               "Robust"
}
else if "`cluster'" != "" {
	qui reg `impute' `varlist'  if `touse', cluster(`cluster')
	mat `Vb'       = e(V)
	local vce       "cluster"
	local vcetype   "Robust"
	local clustvar  "`cluster'"
	local n2_clust = e(N_clust)
}
else {
	qui reg `impute' `varlist'  if `touse'
	mat `Vb'   = e(V)
}

mat    `beta'   = e(b)
scalar `sigma2' = e(rmse)
scalar `n2'     = e(N)
scalar `Rsq2'   = e(r2)

qui testparm `varlist' 
scalar `F'    = r(F)
scalar `Fdf1' = r(df)
scalar `Fdf2' = r(df_r)
scalar `Fp'   = r(p)


gen `ones' = 1 if `touse'
qui matrix accum `Z1X' =  `proxies' `ones' `varlist'  if `touse'
local p  = colsof(`proxymat')
local v  = colsof(`Z1X')-`p'
local p1 = `p'+1
local pv = `p'+`v'

mat `XX' = `Z1X'[`p1'..`pv', `p1'..`pv']
mat `ZZ' = `Z1X'[1..`p', 1..`p']
mat `XZ' = `Z1X'[`p1'..`pv',1.. `p']
mat `ZX' = `XZ''
mat `V'  = (`n1'/`n2')*`Vb' + syminv(`XX')*`XZ'*`Vg'*`ZX'*syminv(`XX')/`Rsq1'/`Rsq1'

cap drop _est_*
ereturn post `beta' `V' , esample(`touse')
ereturn local vce        "`vce'"
ereturn local vcetype    "`vcetype'"
ereturn local clustvar   "`clustvar'"
ereturn local title      "Rescaled regression prediction"
ereturn local cmdline    `"rrp `0'"'
ereturn local depvar     "`impute'"
ereturn local cmd        "rrp"
if ("`cluster'" != "") ereturn scalar N_clust = `n2_clust'
ereturn scalar N    = `n2'
ereturn scalar df_m = `Fdf1'
ereturn scalar df_r = `Fdf2'
ereturn scalar F    = `F'
ereturn scalar r2   = `Rsq2'
ereturn scalar rmse = `sigma2'
ereturn scalar rank = `v'

dis ""
dis "Rescaled regression prediction"
di in gr _col(55) "Number of obs = " in ye %8.0fc `n2' 
di in gr _col(55) "F(" `Fdf1' ", " `Fdf2' ")    = " in ye %8.2f `F' 
di in gr _col(55) "Prob > F      = " in ye %8.4f `Fp'
di in gr _col(55) "R2            = " in ye %8.4f `Rsq2'
di in gr _col(55) "Root MSE      = " in ye %8.4f `sigma2'
ereturn display, level(95)
dis ""
dis "Order of proxies in first-stage:  " "`names1'"
dis "Order of proxies in second-stage: " "`names2'"
end


* -----------------------    VERSION UPDATES    -------------------------------*
* 0.1.0 : 26 Feb 2019 - first version
* 0.2.0 : 18 Jun 2019 - update for unequal sample sizes
* 0.3.0 : 30 Oct 2019 - added options for robust/cluster SE; imputed variable name; improved output

