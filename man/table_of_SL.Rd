% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/table_of_SL.R
\name{table_of_SL}
\alias{table_of_SL}
\title{A Subsetting Function to process SLIPT predictions}
\usage{
table_of_SL(x, significance = "fdr", threshold = 0.05,
  syn_lethal = "strong", ts_sl = TRUE)
}
\arguments{
\item{x}{Data matrix. Synthetic Lethal predictions to process, typically the output of \code{\link[slipt]{detect_SL}}}

\item{significance}{String. Significance condition for p-values to use: none, raw, or adjusted with a valid method for p.adjust() Defaults to fdr (false discovery rate / BH).}

\item{threshold}{Numeric. Significance threshold (alpha, type I error rate) to cut-off (raw or adjusted) p-values. Defaults to 0.05.}

\item{syn_lethal}{String. Stringency of synthetic lethal directional condition. Defaults to 'strong': symmetric replications. Other options are 'query' or 'candidate' or one-directional conditions (which gene is low in a low-high condition) or 'weak' for either one-directional condition.}

\item{ts_sl}{Logical. Defaults to TRUE. Whether to test for synthetic lethality against low or high gene perturbations for tumour supressor gene inactivation (default) or oncogenic overactivation (alternative).}
}
\description{
Extract the predictions synthetic lethal gene partners with synthetic lethal conditions and significance thresholds met.
}
\examples{
#prepare data
 data <- c()
for(i in 1:100){
  data <- cbind(data, rnorm(1000))
}
rm(i)
rownames(data) <- paste("gene", 1:1000)
colnames(data) <- paste("sample", 1:100)
partitioned_data <- prep_data_for_SL(data, n = 3)

#run SLIPT
sl_table <- detect_SL("gene 1", partitioned_data)
dim(sl_table)
head(dim(sl_table))

sl_table <- detect_SL("gene 1", prep_data_for_SL(data))
dim(sl_table)
head(dim(sl_table))

#extract significant hits
short_table <- table_of_SL(sl_table)

}
\keyword{gene}
\keyword{interaction,}
\keyword{lethal,}
\keyword{post-processing,}
\keyword{significance,}
\keyword{slice}
\keyword{subset,}
\keyword{synthetic}
