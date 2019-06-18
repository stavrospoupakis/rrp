* ------------------------------------------------------------------------------
* Title  : Rescaled Regression Prediction (RRP) using two samples
* Author : Stavros Poupakis
* Email  : s.poupakis@gmail.com
* Version: 0.2 (18 June 2019)
* ------------------------------------------------------------------------------


cap program drop rrp
program define rrp, eclass                                                                                    
tempvar ones 
tempname R2_first sigma_first sigma_second n1 n2 ALL XX ZX XZ ZZ beta V

version 14
syntax varlist(numeric) [if] [in] [aweight pweight fweight iweight] [, PROXIES(string) FIRST(string)]

qui est restore `first'
scalar `R2_first'    = e(r2)
scalar `sigma_first' = e(rmse)
scalar `n1'          = e(N)
mat gamma = e(b)

matrix colnames gamma = `proxies' _cons
matrix score double yhatRRP =  gamma  `if' `in'
qui replace yhatRRP = yhatRRP /`R2_first'


qui reg yhatRRP `varlist'  `if' `in'
scalar `sigma_second' = e(rmse)
scalar `n2'           = e(N)
mat `beta' = e(b)
gen `ones' = 1
qui matrix accum `ALL' =  `proxies' `ones' `varlist'  `if' `in'
local p : word count `proxies' 
local p = `p' + 1
local v : word count `varlist'
local v = `v' + 1
local p1 = `p'+1
local PV = `p'+`v'

mat `XX' = `ALL'[`p1'..`PV', `p1'..`PV']
mat `ZZ' = `ALL'[1..`p', 1..`p']
mat `XZ' = `ALL'[`p1'..`PV',1.. `p']
mat `ZX' = `XZ''
mat `V'  = syminv(`XX') * ( `XX' * (`sigma_second'^2) * (`n1'/`n2') + `XZ' * (`sigma_first'^2) * syminv(`ZZ') * `ZX' / `R2_first' / `R2_first'    ) * syminv(`XX') 
cap drop _est_*
ereturn post `beta' `V' 

ereturn display, level(95)


end






