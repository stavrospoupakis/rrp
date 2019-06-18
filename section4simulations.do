* Monte Carlo Experiments as appear in: 
* Crossley, T.F., Levell, P., and Poupakis, S. (2019), 
* Regression with an Imputed Dependent Variable, Working Paper.
* Date: 18 June 2019


clear all
set more off

cap ado uninstall rrp
net install rrp, from("https://raw.githubusercontent.com/spoupakis/rrp/master/")
version 14.2
set seed 12345
global MC = 10000


********************************************************************************
*                                                                              *
*                           one proxy program                                  *
*                                                                              *
********************************************************************************

program define mc_one_proxy, rclass
* Design DGP ---------------------------
drop _all
set obs $n
gen u1 = rnormal(0,$sigma_u)
gen x1 = rnormal(0,2)
gen y1 = 1 + $beta0*x1 + rnormal(0,1)
gen z1 = 1 + $gamma *y1 + u1
gen u2 = rnormal(0,$sigma_u)
gen x2 = rnormal(0,2)
gen y2 = 1 +  $beta0*x2 + rnormal(0,1)
gen z2 = 1 + $gamma * y2 + u2

* FULL ----------------------------------
reg y2 x2
return scalar beta_FULL =   _b[x2]
return scalar   se_FULL =  _se[x2]
* RP  -----------------------------------
reg y1 z1 
gen y2hat_RP = (_b[_cons] + _b[z1]*z2)
reg y2hat_RP x2
return scalar beta_RP    =   _b[x2]
return scalar   se_RP    =  _se[x2]

* RPp -----------------------------------
reg y1 z1 
local Sigma_error = e(rmse)
gen error = rnormal(0, `Sigma_error')
gen y2hat_RPp = y2hat_RP + error
drop error
reg y2hat_RPp x2
return scalar beta_RPp    =   _b[x2]
return scalar   se_RPp    =  _se[x2]

* RRP -------------------------------------
reg y1 z1
return scalar R2 = e(r2)
est store stage1
rrp x2, proxies(z2) first(stage1)
rename yhatRRP y2hat_RRP
return scalar beta_RRP    =   _b[x2]
return scalar   se_RRP    =  _se[x2]

* RRP un-corrected SEs ----------------------
reg y2hat_RRP x2
return scalar   se_ols_RRP  =  _se[x2]

* BPP ---------------------------------------
reg z1 y1 
gen y2hat_BPP = (z2 - _b[_cons]) / _b[y1]
reg y2hat_BPP x2
return scalar beta_BPP    =   _b[x2]
return scalar   se_BPP    =  _se[x2]

* AM ----------------------------------------
reg z2 x2
global bg = _b[x2]
reg z1 y1
global g = _b[y1]
return scalar beta_AM = $bg/$g 

* Store moments -------------------------------
sum y2
return scalar E_FULL = r(mean)
return scalar V_FULL = r(Var)
sum y2hat_RP
return scalar E_RP = r(mean)
return scalar V_RP = r(Var)
sum y2hat_RPp
return scalar E_RPp = r(mean)
return scalar V_RPp = r(Var)
sum y2hat_RRP
return scalar E_RRP = r(mean)
return scalar V_RRP = r(Var)
sum y2hat_BPP
return scalar E_BPP = r(mean)
return scalar V_BPP = r(Var)

end


********************************************************************************
*                                                                              *
*                             two proxies program                              *
*                                                                              *
********************************************************************************

program define mc_two_proxies, rclass

* Design DGP --------------------------------------
drop _all
set obs $n
matrix C = ($sigma_u_a, $rho_u \ $rho_u, $sigma_u_b)
drawnorm ua1 ub1, n($n) cov(C)
gen x1  = rnormal(0,2)
gen y1  = 1 +  $beta0 * x1 + rnormal(0,1)
gen za1 = 1 +  $gamma_a * y1 + ua1
gen zb1 = 1 +  $gamma_b * y1 + ub1
drawnorm ua2 ub2, n($n) cov(C)
gen x2  = rnormal(0,2)
gen y2  = 1 +  $beta0 * x2 + rnormal(0,1)
gen za2 = 1 +  $gamma_a * y2 + ua2
gen zb2 = 1 +  $gamma_b * y2 + ub2

* FULL ------------------------------
reg y2 x2
return scalar beta_FULL =   _b[x2]
return scalar   se_FULL =  _se[x2]

* RP  -------------------------------
reg y1 za1 zb1 
gen y2hat_RP = (_b[_cons] + _b[za1]*za2 + _b[zb1]*zb2)
reg y2hat_RP x2
return scalar beta_RP    =   _b[x2]
return scalar   se_RP    =  _se[x2]

* RPp -------------------------------
reg y1 za1 zb1 
local Sigma_error = e(rmse)
gen error = rnormal(0, `Sigma_error')
gen y2hat_RPp = y2hat_RP + error
drop error
reg y2hat_RPp x2
return scalar beta_RPp    =   _b[x2]
return scalar   se_RPp    =  _se[x2]

* RRP -------------------------------------
reg y1 za1 zb1
return scalar R2 = e(r2)
est store stage1
rrp x2, proxies(za2 zb2) first(stage1)
rename yhatRRP y2hat_RRP
return scalar beta_RRP    =   _b[x2]
return scalar   se_RRP    =  _se[x2]

* RRP un-corrected SEs --------------------
reg y2hat_RRP x2
return scalar   se_ols_RRP  =  _se[x2]

* AM -------------------------------------
reg za2 x2 
global bg_a = _b[x2]
reg za1 y1
global  g_a = _b[y1]
reg zb2 x2
global bg_b = _b[x2]
reg zb1 y1
global  g_b = _b[y1]
return scalar beta_AM = $g_a/($g_a + $g_b) * $bg_a/$g_a   + $g_b/($g_a + $g_b) * $bg_b/$g_b

end


********************************************************************************
*                                                                              *
*                          one proxy 10 bins program                           *
*                                                                              *
********************************************************************************

program define mc_one_proxy10bins, rclass

* Design DGP ---------------------------
drop _all
set obs $n
gen u1 = rnormal(0,$sigma_u)
gen x1 = rnormal(0,2)
gen y1 = 1 + $beta0*x1 + rnormal(0,1)
gen z1 = 1 + $gamma *y1 + u1
gen u2 = rnormal(0,$sigma_u)
gen x2 = rnormal(0,2)
gen y2 = 1 +  $beta0*x2 + rnormal(0,1)
gen z2 = 1 + $gamma * y2 + u2
_pctile z1, n(10)
recode z2 (min/`r(r1)' = 1) (`r(r1)'/`r(r2)' = 2) (`r(r2)'/`r(r3)' = 3) (`r(r3)'/`r(r4)' = 4) (`r(r4)'/`r(r5)' = 5) ///
          (`r(r5)'/`r(r6)' = 6) (`r(r6)'/`r(r7)' = 7) (`r(r7)'/`r(r8)' = 8) (`r(r8)'/`r(r9)' = 9) (`r(r9)'/max= 10)
_pctile z1, n(10)
recode z1 (min/`r(r1)' = 1) (`r(r1)'/`r(r2)' = 2) (`r(r2)'/`r(r3)' = 3) (`r(r3)'/`r(r4)' = 4) (`r(r4)'/`r(r5)' = 5) ///
          (`r(r5)'/`r(r6)' = 6) (`r(r6)'/`r(r7)' = 7) (`r(r7)'/`r(r8)' = 8) (`r(r8)'/`r(r9)' = 9) (`r(r9)'/max= 10)
tab z1, gen(z1bin)
tab z2, gen(z2bin)

* FULL ----------------------------------
reg y2 x2
return scalar beta_FULL =   _b[x2]
return scalar   se_FULL =  _se[x2]

* RP  -----------------------------------
reg y1 i.z1bin2 i.z1bin3 i.z1bin4 i.z1bin5 i.z1bin6 i.z1bin7 i.z1bin8 i.z1bin9 i.z1bin10
gen y2hat_RP = (_b[_cons] + _b[1.z1bin2]*z2bin2 + _b[1.z1bin3]*z2bin3 + _b[1.z1bin4]*z2bin4 + _b[1.z1bin5]*z2bin5 + ///
                _b[1.z1bin6]*z2bin6 + _b[1.z1bin7]*z2bin7 + _b[1.z1bin8]*z2bin8 + _b[1.z1bin9]*z2bin9) + _b[1.z1bin10]*z2bin10
reg y2hat_RP x2
return scalar beta_RP    =   _b[x2]
return scalar   se_RP    =  _se[x2]

* RPp -----------------------------------
reg y1 i.z1bin2 i.z1bin3 i.z1bin4 i.z1bin5 i.z1bin6 i.z1bin7 i.z1bin8 i.z1bin9 i.z1bin10 
local Sigma_error = e(rmse)
gen error = rnormal(0, `Sigma_error')
gen y2hat_RPp = y2hat_RP + error
drop error
reg y2hat_RPp x2
return scalar beta_RPp    =   _b[x2]
return scalar   se_RPp    =  _se[x2]

* RRP -------------------------------------
reg y1 z1bin2 z1bin3 z1bin4 z1bin5 z1bin6 z1bin7 z1bin8 z1bin9 z1bin10 
return scalar R2 = e(r2)
local         R2 = e(r2)
est store stage1
rrp x2, proxies(z2bin2 z2bin3 z2bin4 z2bin5 z2bin6 z2bin7 z2bin8 z2bin9 z2bin10 ) first(stage1)
rename yhatRRP y2hat_RRP
return scalar beta_RRP    =   _b[x2]
return scalar   se_RRP    =  _se[x2]

* RRP un-corrected SEs ----------------------
reg y2hat_RRP x2
return scalar   se_ols_RRP  =  _se[x2]

* Hot Deck regression -----------------------
gen y2_HotD = .
bysort z2: gen Count2 = _n
bysort z2: egen Total2 = max(Count2)
forvalues k = 1/10 {
   sum Total2 if z2==`k'
   global I = `r(max)'
   forvalues i = 1/$I {
      generate  OK = (z1 == `k')
      generate random = runiform()
      sort OK random 
      generate insample = OK & (_N - _n) < 1
      gen draw = y1 if insample==1
      egen draw2 = total(draw)
      sort z2 Count2
      replace y2_HotD = draw2 if z2 == `k' & Count2 == `i'
      drop OK random insample draw draw2 
   }
}
reg y2_HotD x2
return scalar beta_HotD    =   _b[x2]
return scalar   se_HotD    =  _se[x2]

* Hot Deck Rescaled regression ----------------
gen y2_RHotD = y2_HotD/`R2'
reg y2_RHotD x2 
return scalar beta_RHotD    =   _b[x2]
return scalar   se_RHotD    =  _se[x2]

* Store moments -------------------------------
sum y2
return scalar E_FULL = r(mean)
return scalar V_FULL = r(Var)

sum y2hat_RP
return scalar E_RP = r(mean)
return scalar V_RP = r(Var)

sum y2hat_RPp
return scalar E_RPp = r(mean)
return scalar V_RPp = r(Var)

sum y2hat_RRP
return scalar E_RRP = r(mean)
return scalar V_RRP = r(Var)

sum y2_HotD
return scalar E_HotD = r(mean)
return scalar V_HotD = r(Var)

sum y2_RHotD
return scalar E_RHotD = r(mean)
return scalar V_RHotD = r(Var)

end


********************************************************************************
*                                                                              *
*                                simulations                                   *
*                                                                              *
********************************************************************************

* ----------------------------    one proxy    ------------------------------- *
global n = 500
global sigma_u = 1
global gamma = .5
global beta0 = 1
qui simulate    beta_FULL = r(beta_FULL) se_FULL = r(se_FULL) E_FULL = r(E_FULL) V_FULL = r(V_FULL) ///
		beta_RP   = r(beta_RP)   se_RP   = r(se_RP)   E_RP   = r(E_RP)   V_RP   = r(V_RP)   /// 
		beta_RPp  = r(beta_RPp)  se_RPp  = r(se_RPp)  E_RPp  = r(E_RPp)  V_RPp  = r(V_RPp)  ///
		beta_BPP  = r(beta_BPP)  se_BPP  = r(se_BPP)  E_BPP  = r(E_BPP)  V_BPP  = r(V_BPP)  ///
		beta_RRP  = r(beta_RRP)  se_RRP  = r(se_RRP)  E_RRP  = r(E_RRP)  V_RRP  = r(V_RRP)  ///
		se_ols_RRP  = r(se_ols_RRP) beta_AM  = r(beta_AM) R2=r(R2), reps($MC): mc_one_proxy

sum beta* 
sum se*
sum E*
sum V*
sum R2


* ----------------------------    two proxies  ------------------------------- *

* sigma_u_b = 1 ------
global n = 500
global sigma_u_a = 1
global sigma_u_b = 1
global rho_u = -0.5
global gamma_a = .4
global gamma_b = .3
global beta0 = 1
qui simulate 	beta_FULL = r(beta_FULL) se_FULL = r(se_FULL) ///
		beta_RP   = r(beta_RP)   se_RP   = r(se_RP)   ///
		beta_RPp  = r(beta_RPp)  se_RPp  = r(se_RPp)  ///
		beta_RRP  = r(beta_RRP)  se_RRP  = r(se_RRP)  se_ols_RRP  = r(se_ols_RRP) ///
		beta_AM   = r(beta_AM)   R2=r(R2), reps($MC): mc_two_proxies
sum beta*
sum se*
sum R2

* sigma_u_b = 2 ------
global n = 500
global sigma_u_a = 1
global sigma_u_b = 2
global rho_u = -0.5
global gamma_a = .4
global gamma_b = .3
global beta0 = 1
qui simulate 	beta_FULL = r(beta_FULL) se_FULL = r(se_FULL) ///
		beta_RP   = r(beta_RP)   se_RP   = r(se_RP)   ///
		beta_RPp  = r(beta_RPp)  se_RPp  = r(se_RPp)  ///
		beta_RRP  = r(beta_RRP)  se_RRP  = r(se_RRP)  se_ols_RRP  = r(se_ols_RRP) ///
		beta_AM   = r(beta_AM)   R2=r(R2), reps($MC): mc_two_proxies
sum beta*
sum se*
sum R2

* sigma_u_b = 4 ------
global n = 500
global sigma_u_a = 1
global sigma_u_b = 4
global rho_u = -0.5
global gamma_a = .4
global gamma_b = .3
global beta0 = 1
qui simulate 	beta_FULL = r(beta_FULL) se_FULL = r(se_FULL) ///
		beta_RP   = r(beta_RP)   se_RP   = r(se_RP)   ///
		beta_RPp  = r(beta_RPp)  se_RPp  = r(se_RPp)  ///
		beta_RRP  = r(beta_RRP)  se_RRP  = r(se_RRP)  se_ols_RRP  = r(se_ols_RRP) ///
		beta_AM   = r(beta_AM)   R2=r(R2), reps($MC): mc_two_proxies
sum beta*
sum se*
sum R2


* -------------------------    one proxy 10 bins    -------------------------- *
global n = 500
global sigma_u = 1
global gamma = .5
global beta0 = 1
qui simulate 	beta_FULL  = r(beta_FULL)  se_FULL  = r(se_FULL)  E_FULL  = r(E_FULL)  V_FULL  = r(V_FULL)  ///
		beta_RP    = r(beta_RP)    se_RP    = r(se_RP)    E_RP    = r(E_RP)    V_RP    = r(V_RP)    ///
		beta_RPp   = r(beta_RPp)   se_RPp   = r(se_RPp)   E_RPp   = r(E_RPp)   V_RPp   = r(V_RPp)   ///
		beta_HotD  = r(beta_HotD)  se_HotD  = r(se_HotD)  E_HotD  = r(E_HotD)  V_HotD  = r(V_HotD)  ///
		beta_RHotD = r(beta_RHotD) se_RHotD = r(se_RHotD) E_RHotD = r(E_RHotD) V_RHotD = r(V_RHotD) ///
		beta_RRP   = r(beta_RRP)   se_RRP   = r(se_RRP)   E_RRP   = r(E_RRP)   V_RRP   = r(V_RRP)   ///
		se_ols_RRP = r(se_ols_RRP) R2=r(R2),  reps($MC): mc_one_proxy10bins
sum beta* 
sum se*
sum E*
sum V*
sum R2



********************************************************************************
*                                 The End                                      *
********************************************************************************




