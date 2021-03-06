% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rcorrvar.R
\name{rcorrvar}
\alias{rcorrvar}
\title{Generation of Correlated Ordinal, Continuous, Poisson, and/or Negative Binomial Variables: Correlation Method 1}
\usage{
rcorrvar(n = 10000, k_cont = 0, k_cat = 0, k_pois = 0, k_nb = 0,
  method = c("Fleishman", "Polynomial"), means = NULL, vars = NULL,
  skews = NULL, skurts = NULL, fifths = NULL, sixths = NULL,
  Six = list(), marginal = list(), support = list(), nrand = 100000,
  lam = NULL, size = NULL, prob = NULL, mu = NULL, Sigma = NULL,
  rho = NULL, cstart = NULL, seed = 1234, errorloop = FALSE,
  epsilon = 0.001, maxit = 1000, extra_correct = TRUE)
}
\arguments{
\item{n}{the sample size (i.e. the length of each simulated variable; default = 10000)}

\item{k_cont}{the number of continuous variables (default = 0)}

\item{k_cat}{the number of ordinal (r >= 2 categories) variables (default = 0)}

\item{k_pois}{the number of Poisson variables (default = 0)}

\item{k_nb}{the number of Negative Binomial variables (default = 0)}

\item{method}{the method used to generate the k_cont continuous variables.  "Fleishman" uses Fleishman's third-order polynomial transformation
and "Polynomial" uses Headrick's fifth-order transformation.}

\item{means}{a vector of means for the k_cont continuous variables (i.e. = rep(0, k_cont))}

\item{vars}{a vector of variances (i.e. = rep(1, k_cont))}

\item{skews}{a vector of skewness values (i.e. = rep(0, k_cont))}

\item{skurts}{a vector of standardized kurtoses (kurtosis - 3, so that normal variables have a value of 0; i.e. = rep(0, k_cont))}

\item{fifths}{a vector of standardized fifth cumulants (not necessary for \code{method} = "Fleishman"; i.e. = rep(0, k_cont))}

\item{sixths}{a vector of standardized sixth cumulants (not necessary for \code{method} = "Fleishman"; i.e. = rep(0, k_cont))}

\item{Six}{a list of vectors of correction values to add to the sixth cumulants if no valid pdf constants are found,
ex: \code{Six = list(seq(0.01, 2,by = 0.01), seq(1, 10,by = 0.5))}; if no correction is desired for variable Y_i, set set the i-th list
component equal to NULL}

\item{marginal}{a list of length equal to \code{k_cat}; the i-th element is a vector of the cumulative
probabilities defining the marginal distribution of the i-th variable;
if the variable can take r values, the vector will contain r - 1 probabilities (the r-th is assumed to be 1; default = list());
for binary variables, these should be input the same as for ordinal variables with more than 2 categories (i.e. the user-specified
probability is the probability of the 1st category, which has the smaller support value)}

\item{support}{a list of length equal to \code{k_cat}; the i-th element is a vector containing the r ordered support values;
if not provided (i.e. \code{support = list()}), the default is for the i-th element to be the
vector 1, ..., r}

\item{nrand}{the number of random numbers to generate in calculating intermediate correlations (default = 10000)}

\item{lam}{a vector of lambda (> 0) constants for the Poisson variables (see \code{\link[stats]{Poisson}})}

\item{size}{a vector of size parameters for the Negative Binomial variables (see \code{\link[stats]{NegBinomial}})}

\item{prob}{a vector of success probability parameters}

\item{mu}{a vector of mean parameters (*Note: either \code{prob} or \code{mu} should be supplied for all Negative Binomial variables,
not a mixture; default = NULL)}

\item{Sigma}{an intermediate correlation matrix to use if the user wants to provide one (default = NULL)}

\item{rho}{the target correlation matrix (\emph{must be ordered ordinal, continuous, Poisson, Negative Binomial}; default = NULL)}

\item{cstart}{a list containing initial values for root-solving algorithm used in \code{\link[SimMultiCorrData]{find_constants}}
(see \code{\link[BB]{multiStart}} for \code{method} = "Fleishman" or \code{\link[nleqslv]{nleqslv}} for \code{method} = "Polynomial").
If user specified, each list element must be input as a matrix. If no starting values are specified for a given continuous
variable, that list element should be NULL.  If NULL and all 4 standardized cumulants (rounded to 3 digits) are within
0.01 of those in Headrick's common distribution table (see \code{\link[SimMultiCorrData]{Headrick.dist}}
data), uses his constants as starting values; else, generates n sets of random starting values from
uniform distributions.}

\item{seed}{the seed value for random number generation (default = 1234)}

\item{errorloop}{if TRUE, uses \code{\link[SimMultiCorrData]{error_loop}} to attempt to correct the final correlation
(default = FALSE)}

\item{epsilon}{the maximum acceptable error between the final and target correlation matrices (default = 0.001)
in the calculation of ordinal intermediate correlations with \code{\link[SimMultiCorrData]{ordnorm}} or in the error loop}

\item{maxit}{the maximum number of iterations to use (default = 1000) in the calculation of ordinal
intermediate correlations with \code{\link[SimMultiCorrData]{ordnorm}} or in the error loop}

\item{extra_correct}{if TRUE, within each variable pair, if the maximum correlation error is still greater than 0.1, the intermediate
correlation is set equal to the target correlation (with the assumption that the calculated final correlation will be
less than 0.1 away from the target)}
}
\value{
A list whose components vary based on the type of simulated variables.  Simulated variables are returned as data.frames:

If \bold{ordinal variables} are produced:

    \code{ordinal_variables} the generated ordinal variables,

    \code{summary_ordinal} a list, where the i-th element contains a data.frame with column 1 = target cumulative probabilities and
    column 2 = simulated cumulative probabilities for ordinal variable Y_i

If \bold{continuous variables} are produced:

    \code{constants} a data.frame of the constants,

    \code{continuous_variables} the generated continuous variables,

    \code{summary_continuous} a data.frame containing a summary of each variable,

    \code{summary_targetcont} a data.frame containing a summary of the target variables,

    \code{sixth_correction} a vector of sixth cumulant correction values,

    \code{valid.pdf} a vector where the i-th element is "TRUE" if the constants for the i-th continuous variable generate a valid pdf,
                else "FALSE"

If \bold{Poisson variables} are produced:

    \code{Poisson_variables} the generated Poisson variables,

    \code{summary_Poisson} a data.frame containing a summary of each variable

If \bold{Negative Binomial variables} are produced:

    \code{Neg_Bin_variables} the generated Negative Binomial variables,

    \code{summary_Neg_Bin} a data.frame containing a summary of each variable

Additionally, the following elements:

    \code{correlations} the final correlation matrix,

    \code{Sigma1} the intermediate correlation before the error loop,

    \code{Sigma2} the intermediate correlation matrix after the error loop,

    \code{Constants_Time} the time in minutes required to calculate the constants,

    \code{Intercorrelation_Time} the time in minutes required to calculate the intermediate correlation matrix,

    \code{Error_Loop_Time} the time in minutes required to use the error loop,

    \code{Simulation_Time} the total simulation time in minutes,

    \code{niter} a matrix of the number of iterations used for each variable in the error loop,

    \code{maxerr} the maximum final correlation error (from the target rho).

    If a particular element is not required, the result is NULL for that element.
}
\description{
This function simulates \code{k_cat} ordinal, \code{k_cont} continuous, \code{k_pois} Poisson, and/or \code{k_nb}
    Negative Binomial variables with
    a specified correlation matrix \code{rho}.  The variables are generated from multivariate normal variables with intermediate correlation
    matrix \code{Sigma}, calculated by \code{\link[SimMultiCorrData]{findintercorr}}, and then transformed.  The \emph{ordering} of the
    variables in \code{rho} must be \emph{ordinal} (r >= 2 categories), \emph{continuous}, \emph{Poisson}, and \emph{Negative Binomial}
    (note that it is possible for \code{k_cat}, \code{k_cont}, \code{k_pois}, and/or \code{k_nb} to be 0).  The vignette
    \bold{Overall Workflow for Data Simulation} provides a detailed example discussing the step-by-step simulation process and comparing
    correlation methods 1 and 2.
}
\section{Variable Types and Required Inputs}{

1) \bold{Continuous Variables:} Continuous variables are simulated using either Fleishman's third-order (\code{method} = "Fleishman",
\doi{10.1007/BF02293811}) or Headrick's fifth-order (\code{method} = "Polynomial", \doi{10.1016/S0167-9473(02)00072-5}) power method
transformation.  This is a computationally efficient algorithm that simulates continuous distributions through the method of moments.
It works by matching standardized cumulants -- the first four (mean, variance, skew, and standardized kurtosis) for Fleishman's method, or
the first six (mean, variance, skew, standardized kurtosis, and standardized fifth and sixth cumulants) for Headrick's method.  The
transformation is expressed as follows:

\eqn{Y = c_{0} + c_{1} * Z + c_{2} * Z^2 + c_{3} * Z^3 + c_{4} * Z^4 + c_{5} * Z^5},

where \eqn{Z ~ N(0,1)}, and \eqn{c_{4}} and \eqn{c_{5}} both equal \eqn{0} for Fleishman's method.  The real constants are calculated by
\code{\link[SimMultiCorrData]{find_constants}}.  All variables are simulated with mean \eqn{0} and variance \eqn{1}, and then transformed
to the specified mean and variance at the end.

The required parameters for simulating continuous variables include: mean, variance, skewness, standardized kurtosis (kurtosis - 3), and
standardized fifth and sixth cumulants (for \code{method} = "Polynomial").  If the goal is to simulate a theoretical distribution
(i.e. Gamma, Beta, Logistic, etc.), these values can be obtained using \code{\link[SimMultiCorrData]{calc_theory}}.  If the goal is to
mimic an empirical data set, these values can be found using \code{\link[SimMultiCorrData]{calc_moments}} (using the method of moments) or
\code{\link[SimMultiCorrData]{calc_fisherk}} (using Fisher's k-statistics).  If the standardized cumulants
are obtained from \code{calc_theory}, the user may need to use rounded values as inputs (i.e. \code{skews = round(skews, 8)}).  Due to the nature
of the integration involved in \code{calc_theory}, the results are approximations.  Greater accuracy can be achieved by increasing the number of
subdivisions (\code{sub}) used in the integration process.  For example, in order to ensure that skew is exactly 0 for symmetric distributions.

For some sets of cumulants, it is either not possible to find
power method constants or the calculated constants do not generate valid power method pdfs.  In these situations, adding a value to the
sixth cumulant may provide solutions (see \code{\link[SimMultiCorrData]{find_constants}}).  When using Headrick's fifth-order approximation,
if simulation results indicate that a
continuous variable does not generate a valid pdf, the user can try \code{\link[SimMultiCorrData]{find_constants}} with various sixth
cumulant correction vectors to determine if a valid pdf can be found.

2) \bold{Binary and Ordinal Variables:} Ordinal variables (\eqn{r \ge 2} categories) are generated by discretizing the standard normal variables
at quantiles.  These quantiles are determined by evaluating the inverse standard normal cdf at the cumulative probabilities defined by each
variable's marginal distribution.  The required inputs for ordinal variables are the cumulative marginal probabilities and support values
(if desired).  The probabilities should be combined into a list of length equal to the number of ordinal variables.  The \eqn{i^{th}} element
is a vector of the cumulative probabilities defining the marginal distribution of the \eqn{i^{th}} variable.  If the variable can take
\eqn{r} values, the vector will contain \eqn{r - 1} probabilities (the \eqn{r^{th}} is assumed to be \eqn{1}).

\emph{Note for binary variables:} the user-suppled probability should be the probability of the \eqn{1^{st}} (lower) support value.  This would
ordinarily be considered the probability of \emph{failure} (\eqn{q}), while the probability of the \eqn{2^{nd}} (upper) support value would be
considered the probability of \emph{success} (\eqn{p = 1 - q}).  The support values should be combined into a separate list.  The \eqn{i^{th}}
element is a vector containing the \eqn{r} ordered support values.

3) \bold{Count Variables:} Count variables are generated using the inverse cdf method.  The cumulative distribution function of a standard
normal variable has a uniform distribution.  The appropriate quantile function \eqn{F_{Y}^{-1}} is applied to this uniform variable with the
designated parameters to generate the count variable: \eqn{Y = F_{y}^{-1}(\Phi(Z))}.  For Poisson variables, the lambda (mean) value should be
given.  For Negative Binomial variables, the size (target number of successes) and either the success probability or the mean should be given.
The Negative Binomial variable represents the number of failures which occur in a sequence of Bernoulli trials before the target number of
successes is achieved.

More details regarding the variable types can be found in the \bold{Variable Types} vignette.
}

\section{Overview of Correlation Method 1}{

    The intermediate correlations used in correlation method 1 are more simulation based than those in method 2, which means that accuracy
    increases with sample size and the number of repetitions.  In addition, specifying the seed allows for reproducibility.  In
    addition, method 1 differs from method 2 in the following ways:

    1) The intermediate correlation for \bold{count variables} is based on the method of Yahav & Shmueli (2012, \doi{10.1002/asmb.901}), which
    uses a simulation based, logarithmic transformation of the target correlation.  This method becomes less accurate as the variable mean
    gets closer to zero.

    2) The \bold{ordinal - count variable} correlations are based on an extension of the method of Amatya & Demirtas (2015,
    \doi{10.1080/00949655.2014.953534}), in which
    the correlation correction factor is the product of the upper Frechet-Hoeffding bound on the correlation between the count
    variable and the normal variable used to generate it and a simulated upper bound on the correlation between an ordinal variable
    and the normal variable used to generate it (see Demirtas & Hedeker, 2011, \doi{10.1198/tast.2011.10090}).

    3) The \bold{continuous - count variable} correlations are based on an extension of the methods of Amatya & Demirtas (2015) and
    Demirtas et al. (2012, \doi{10.1002/sim.5362}), in which the correlation correction factor is the product of the upper Frechet-Hoeffding bound
    on the correlation between the count variable and the normal variable used to generate it and the power method correlation
    between the continuous variable and the normal variable used to generate it (see Headrick & Kowalchuk, 2007, \doi{10.1080/10629360600605065}).
    The intermediate correlations are the ratio of the target correlations to the correction factor.

    Please see the \bold{Comparison of Method 1 and Method 2} vignette for more information and an step-by-step overview of the
    simulation process.
}

\section{Choice of Fleishman's third-order or Headrick's fifth-order method}{

    Using the fifth-order approximation allows additional control over the fifth and sixth moments of the generated distribution, improving
    accuracy.  In addition, the range of feasible standardized kurtosis values, given skew and standardized fifth (\eqn{\gamma_{3}}) and sixth
    (\eqn{\gamma_{4}}) cumulants, is larger than with Fleishman's method (see \code{\link[SimMultiCorrData]{calc_lower_skurt}}).
    For example, the Fleishman method can not be used to generate a
    non-normal distribution with a ratio of \eqn{\gamma_{3}^2/\gamma_{4} > 9/14} (see Headrick & Kowalchuk, 2007).
    This eliminates the
    Chi-squared family of distributions, which has a constant ratio of \eqn{\gamma_{3}^2/\gamma_{4} = 2/3}.  However, if the fifth and
    sixth cumulants do not exist, the Fleishman approximation should be used.
}

\section{Reasons for Function Errors}{

    1) The most likely cause for function errors is that no solutions to \code{\link[SimMultiCorrData]{fleish}} or
    \code{\link[SimMultiCorrData]{poly}} converged when using \code{\link[SimMultiCorrData]{find_constants}}.  If this happens,
    the simulation will stop.  It may help to first use \code{\link[SimMultiCorrData]{find_constants}} for each continuous variable to
    determine if a vector of sixth cumulant correction values is needed.  The solutions can be used as starting values (see \code{cstart} below).
    If the standardized cumulants are obtained from \code{calc_theory}, the user may need to use rounded values as inputs (i.e.
    \code{skews = round(skews, 8)}).

    2) In addition, the kurtosis may be outside the region of possible values.  There is an associated lower boundary for kurtosis associated
    with a given skew (for Fleishman's method) or skew and fifth and sixth cumulants (for Headrick's method).  Use
    \code{\link[SimMultiCorrData]{calc_lower_skurt}} to determine the boundary for a given set of cumulants.

    3) As mentioned above, the feasibility of the final correlation matrix rho, given the
    distribution parameters, should be checked first using \code{\link[SimMultiCorrData]{valid_corr}}.  This function either checks
    if a given \code{rho} is plausible or returns the lower and upper final correlation limits.  It should be noted that even if a target
    correlation matrix is within the "plausible range," it still may not be possible to achieve the desired matrix.  This happens most
    frequently when generating ordinal variables (r >= 2 categories).  The error loop frequently fixes these problems.
}

\examples{
Sim1 <- rcorrvar(n = 1000, k_cat = 1, k_cont = 1, method = "Polynomial",
  means = 0, vars = 1, skews = 0, skurts = 0, fifths = 0, sixths = 0,
  marginal = list(c(1/3, 2/3)), support = list(0:2),
  rho = matrix(c(1, 0.4, 0.4, 1), 2, 2))

\dontrun{

# Binary, Ordinal, Continuous, Poisson, and Negative Binomial Variables

options(scipen = 999)
seed <- 1234
n <- 10000

Dist <- c("Logistic", "Weibull")
Params <- list(c(0, 1), c(3, 5))
Stcum1 <- calc_theory(Dist[1], Params[[1]])
Stcum2 <- calc_theory(Dist[2], Params[[2]])
Stcum <- rbind(Stcum1, Stcum2)
rownames(Stcum) <- Dist
colnames(Stcum) <- c("mean", "sd", "skew", "skurtosis", "fifth", "sixth")
Stcum
Six <- list(seq(1.7, 1.8, 0.01), seq(0.10, 0.25, 0.01))
marginal <- list(0.3)
lam <- 0.5
size <- 2
prob <- 0.75

Rey <- matrix(0.4, 5, 5)
diag(Rey) <- 1

# Make sure Rey is within upper and lower correlation limits
valid <- valid_corr(k_cat = 1, k_cont = 2, k_pois = 1, k_nb = 1,
                    method = "Polynomial", means = Stcum[, 1],
                    vars = Stcum[, 2]^2, skews = Stcum[, 3],
                    skurts = Stcum[, 4], fifths = Stcum[, 5],
                    sixths = Stcum[, 6], Six = Six, marginal = marginal,
                    lam = lam, size = size, prob = prob, rho = Rey,
                    seed = seed)

# Simulate variables without error loop
Sim1 <- rcorrvar(n = n, k_cat = 1, k_cont = 2, k_pois = 1, k_nb = 1,
                 method = "Polynomial", means = Stcum[, 1],
                 vars = Stcum[, 2]^2, skews = Stcum[, 3],
                 skurts = Stcum[, 4], fifths = Stcum[, 5],
                 sixths = Stcum[, 6], Six = Six, marginal = marginal,
                 lam = lam, size = size, prob = prob, rho = Rey,
                 seed = seed)
names(Sim1)

# Look at the maximum correlation error
Sim1$maxerr

Sim1_error = round(Sim1$correlations - Rey, 6)

# interquartile-range of correlation errors
quantile(as.numeric(Sim1_error), 0.25)
quantile(as.numeric(Sim1_error), 0.75)

# Simulate variables with error loop
Sim1_EL <- rcorrvar(n = n, k_cat = 1, k_cont = 2,
                    k_pois = 1, k_nb = 1, method = "Polynomial",
                    means = Stcum[, 1], vars = Stcum[, 2]^2,
                    skews = Stcum[, 3], skurts = Stcum[, 4],
                    fifths = Stcum[, 5], sixths = Stcum[, 6],
                    Six = Six, marginal = marginal, lam = lam,
                    size = size, prob = prob, rho = Rey,
                    seed = seed, errorloop = TRUE)
# Look at the maximum correlation error
Sim1_EL$maxerr

EL_error = round(Sim1_EL$correlations - Rey, 6)

# interquartile-range of correlation errors
quantile(as.numeric(EL_error), 0.25)
quantile(as.numeric(EL_error), 0.75)

# Look at results
# Ordinal variables
Sim1_EL$summary_ordinal

# Continuous variables
round(Sim1_EL$constants, 6)
round(Sim1_EL$summary_continuous, 6)
round(Sim1_EL$summary_targetcont, 6)
Sim1_EL$valid.pdf

# Count variables
Sim1_EL$summary_Poisson
Sim1_EL$summary_Neg_Bin

# Generate Plots

# Logistic (1st continuous variable)
# 1) Simulated Data CDF (find cumulative probability up to y = 0.5)
plot_sim_cdf(Sim1_EL$continuous_variables[, 1], calc_cprob = TRUE,
             delta = 0.5)

# 2) Simulated Data and Target Distribution PDFs
plot_sim_pdf_theory(Sim1_EL$continuous_variables[, 1], Dist = "Logistic",
                    params = c(0, 1))

# 3) Simulated Data and Target Distribution
plot_sim_theory(Sim1_EL$continuous_variables[, 1], Dist = "Logistic",
                params = c(0, 1))

}
}
\references{
Amatya A & Demirtas H (2015). Simultaneous generation of multivariate mixed data with Poisson and normal marginals.
    Journal of Statistical Computation and Simulation, 85(15): 3129-39. \doi{10.1080/00949655.2014.953534}.

Barbiero A, Ferrari PA (2015). GenOrd: Simulation of Discrete Random Variables with Given
    Correlation Matrix and Marginal Distributions. R package version 1.4.0. \url{https://CRAN.R-project.org/package=GenOrd}

Demirtas H & Hedeker D (2011). A practical way for computing approximate lower and upper correlation bounds.
    American Statistician, 65(2): 104-109. \doi{10.1198/tast.2011.10090}.

Demirtas H, Hedeker D, & Mermelstein RJ (2012). Simulation of massive public health data by power polynomials.
    Statistics in Medicine, 31(27): 3337-3346. \doi{10.1002/sim.5362}.

Ferrari PA, Barbiero A (2012). Simulating ordinal data. Multivariate Behavioral Research, 47(4): 566-589.
    \doi{10.1080/00273171.2012.692630}.

Fleishman AI (1978). A Method for Simulating Non-normal Distributions. Psychometrika, 43, 521-532. \doi{10.1007/BF02293811}.

Frechet M.  Sur les tableaux de correlation dont les marges sont donnees.  Ann. l'Univ. Lyon SectA.  1951;14:53-77.

Hasselman B (2018). nleqslv: Solve Systems of Nonlinear Equations. R package version 3.3.2.
    \url{https://CRAN.R-project.org/package=nleqslv}

Headrick TC (2002). Fast Fifth-order Polynomial Transforms for Generating Univariate and Multivariate
    Non-normal Distributions. Computational Statistics & Data Analysis, 40(4):685-711. \doi{10.1016/S0167-9473(02)00072-5}.
    (\href{http://www.sciencedirect.com/science/article/pii/S0167947302000725}{ScienceDirect})

Headrick TC (2004). On Polynomial Transformations for Simulating Multivariate Nonnormal Distributions.
    Journal of Modern Applied Statistical Methods, 3(1), 65-71. \doi{10.22237/jmasm/1083370080}.

Headrick TC, Kowalchuk RK (2007). The Power Method Transformation: Its Probability Density Function, Distribution
    Function, and Its Further Use for Fitting Data. Journal of Statistical Computation and Simulation, 77, 229-249. \doi{10.1080/10629360600605065}.

Headrick TC, Sawilowsky SS (1999). Simulating Correlated Non-normal Distributions: Extending the Fleishman Power
    Method. Psychometrika, 64, 25-35. \doi{10.1007/BF02294317}.

Headrick TC, Sheng Y, & Hodis FA (2007). Numerical Computing and Graphics for the Power Method Transformation Using
    Mathematica. Journal of Statistical Software, 19(3), 1 - 17. \doi{10.18637/jss.v019.i03}.

Higham N (2002). Computing the nearest correlation matrix - a problem from finance; IMA Journal of Numerical Analysis 22: 329-343.

Hoeffding W. Scale-invariant correlation theory. In: Fisher NI, Sen PK, editors. The collected works of Wassily Hoeffding.
    New York: Springer-Verlag; 1994. p. 57-107.

Olsson U, Drasgow F, & Dorans NJ (1982). The Polyserial Correlation Coefficient. Psychometrika, 47(3): 337-47.
    \doi{10.1007/BF02294164}.

Vale CD & Maurelli VA (1983). Simulating Multivariate Nonnormal Distributions. Psychometrika, 48, 465-471. \doi{10.1007/BF02293687}.

Varadhan R, Gilbert P (2009). BB: An R Package for Solving a Large System of Nonlinear Equations and for
    Optimizing a High-Dimensional Nonlinear Objective Function, J. Statistical Software, 32(4). \doi{10.18637/jss.v032.i04}.
    \url{http://www.jstatsoft.org/v32/i04/}

Yahav I & Shmueli G (2012). On Generating Multivariate Poisson Data in Management Science Applications. Applied Stochastic
    Models in Business and Industry, 28(1): 91-102. \doi{10.1002/asmb.901}.
}
\seealso{
\code{\link[SimMultiCorrData]{find_constants}}, \code{\link[SimMultiCorrData]{findintercorr}},
    \code{\link[BB]{multiStart}}, \code{\link[nleqslv]{nleqslv}}
}
\keyword{Binomial,}
\keyword{Fleishman,}
\keyword{Headrick,}
\keyword{Negative}
\keyword{Poisson,}
\keyword{continuous,}
\keyword{method1}
\keyword{ordinal,}
\keyword{simulation,}
