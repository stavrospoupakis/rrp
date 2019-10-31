{smcl}
{* *! version 0.3.0 October 2019}{...}

{cmd:help rrp}{right: ({browse "https://github.com/spoupakis/rrp":GitHub})}
{hline}

{title:Title}

{p 8 20 2}
{hi:rrp} {hline 2} Rescaled Regression Prediction (RRP) using two samples{p_end}


{title:Syntax}

{p 8 17 2}
{cmd:rrp}
{indepvars}
{ifin}{weight}{cmd:,}
{cmdab:impute(}{newvar}{cmd:)} 
{cmdab:proxies(}{varlist}{cmd:)} 
{cmdab:first(}{it:{help estimates_store:model}}{cmd:)} 
{cmdab:r:obust} 
{cmdab:cl:uster(}clustvar{cmd:)} 
{cmdab:h:ide} 

{title:Description}

{pstd}{cmd:rrp} implements a Rescaled Regression Prediction (RRP) using two samples in two steps. 
First it creates a new variable, by imputing the dependent variable in the current dataset, 
using the stored first-stage regression, fitted in the dataset that contains the dependent variable 
and the proxies. The command does not check (nor it requires) whether the proxies used in the 
two datasets have the same names, or the same order in the first stage and in the {hi:proxies()} option, 
thus it is upon the user to ensure the correct ordering of the proxy variables. The command returns 
the results of the second-stage regression and creates the new imputed variable.


{title:Options}

{phang}
{cmdab:impute(}{newvar}{cmd:)} is used to select the name of the new imputed variable
{p_end}

{phang}
{cmdab:proxies(}{varlist}{cmd:)} specifies the variables, common at both datasets, used as proxies for imputing the dependent variable.
{p_end}

{phang}
{cmdab:first(}{it:{help estimates_store:model}}{cmd:)} specifies the first-stage regression in the dataset that contains the dependent variable.
{p_end}

{phang}
{cmdab:r:obust} is used to calcualte standard errors that are robust to the presence of arbitrary heteroskedasticity.
{p_end}

{phang}
{cmdab:cl:uster(}clustvar{cmd:)} is used to calculate standard errors that are robust to both arbitrary heteroskedasticity and allow intra-group correlation.
{p_end}

{phang}
{cmdab:hide} do not display the order of proxies
{p_end}

{title:Example}


{phang2}{cmd:. drop _all}{p_end}
{phang2}{cmd:. set obs 500}{p_end}
{phang2}{cmd:. gen u1 = rnormal(0,1)}{p_end}
{phang2}{cmd:. gen x1 = rnormal(0,2)}{p_end}
{phang2}{cmd:. gen y1 = 1 + 1*x1 + rnormal(0,1)}{p_end}
{phang2}{cmd:. gen z1 = 1 + 0.5*y1 + u1}{p_end}
{phang2}{cmd:. gen u2 = rnormal(0,1)}{p_end}
{phang2}{cmd:. gen x2 = rnormal(0,2)}{p_end}
{phang2}{cmd:. gen y2 = 1 +  1*x2 + rnormal(0,1)}{p_end}
{phang2}{cmd:. gen z2 = 1 + 0.5* y2 + u2}{p_end}

{phang2}{cmd:. reg y1 z1}{p_end}
{phang2}{cmd:. est store stage1}{p_end}
{phang2}{cmd:. rrp x2, impute(yhat2) proxies(z2) first(stage1)}{p_end}



{title:Saved results}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(rank)}}rank of e(V){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:rrp}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of imputed dependent variable{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(vce)}}vcetype specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}



{title:Reference}
{phang}
Crossley, T.F., Levell, P., and Poupakis, S. (2019). {it:Regression with an Imputed Dependent Variable}, IFS Working Paper W19/16.
{p_end}

{title:Author}

{pstd}Stavros Poupakis{p_end}
{pstd}University of Oxford{p_end}
{pstd}stavros.poupakis@oxfordmartin.ox.ac.uk{p_end}

