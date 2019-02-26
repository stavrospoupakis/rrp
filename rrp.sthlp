{smcl}
{* *! version 0.1.0 February 2019}{...}

{cmd:help rrp}{right: ({browse "https://github.com/spoupakis/rrp":GitHub})}
{hline}

{title:Title}

{p 8 20 2}
{hi:rwolf} {hline 2} Rescaled Regression Prediction (RRP) using two samples{p_end}



{title:Syntax}

{p 8 17 2}
{cmd:rrp}
{indepvars}{cmd:,}
{cmdab:proxies(}{varlist}{cmd:)} 
{cmdab:first(}{it:{help estimates_store:model}}{cmd:)} 


{title:Description}

{pstd}{cmd:rrp} implements a Rescaled Regression Prediction (RRP) using two samples in two steps. 
First it creates a new variable, by imputing the dependent variable in the current dataset, 
using the stored first-stage regression, fitted in the dataset that contains the dependent variable 
and the proxies. The command does not check (nor it requires) whether the proxies used in the 
two datasets have the same names, or the same order in the first stage and in the {hi:proxies()} option, 
thus it is upon the user to ensure the correct ordering of the proxy variables. The command prints 
the results of the second-stage regression, i.e. regressing the imputed dependent variable on the {hi:varlist}. 
In addition, it creates a new variable, named {hi:yhatRRP}, that is the imputed dependent variable in the current dataset.


{title:Options}

{phang}
{cmdab:proxies(}{varlist}{cmd:)} specifies the variables, common at both datasets, used as proxies for imputing the dependent variable.
{p_end}

{phang}
{cmdab:first(}{it:{help estimates_store:model}}{cmd:)} specifies the first-stage regression in the dataset that contains the dependent variable.
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
{phang2}{cmd:. rrp x2, proxies(z2) first(stage1)}{p_end}




{title:Reference}
{phang}
Crossley, T.F., Levell, P., and Poupakis, S. (2019). {it:Regression with an Imputed Dependent Variable}, Working Paper.
{p_end}

{title:Author}

{pstd}Stavros Poupakis, Department of Economics, University College London, spoupakis@gmail.com{p_end}

