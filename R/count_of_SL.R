#' A Count Function to process SLIPT predictions
#'
#' Count number of predicted synthetic lethal gene partners with synthetic lethal conditions and significance thresholds met.
#' @param x Data matrix. Synthetic Lethal predictions to process, typically the output of \code{\link[slipt]{detect_SL}}
#' @param significance String. Significance condition for p-values to use: none, raw, or adjusted with a valid method for p.adjust() Defaults to fdr (false discovery rate / BH).
#' @param threshold Numeric. Significance threshold (alpha, type I error rate) to cut-off (raw or adjusted) p-values. Defaults to 0.05.
#' @param syn_lethal String. Stringency of synthetic lethal directional condition. Defaults to 'strong': symmetric replications. Other options are 'query' or 'candidate' or one-directional conditions (which gene is low in a low-high condition) or 'weak' for either one-directional condition.
#' @param ts_sl Logical. Defaults to TRUE. Whether to test for synthetic lethality against low or high gene perturbations for tumour supressor gene inactivation (default) or oncogenic overactivation (alternative).
#' @keywords synthetic lethal, gene interaction, significance, post-processing, subset, slice
#' @export
#' @examples
#' #prepare data
#'  data <- c()
#' for(i in 1:100){
#'   data <- cbind(data, rnorm(1000))
#' }
#' rm(i)
#' rownames(data) <- paste("gene", 1:1000)
#' colnames(data) <- paste("sample", 1:100)
#' partitioned_data <- prep_data_for_SL(data, n = 3)
#'
#' #run SLIPT
#' sl_table <- detect_SL("gene 1", partitioned_data)
#' dim(sl_table)
#' head(dim(sl_table))
#'
#' sl_table <- detect_SL("gene 1", prep_data_for_SL(data))
#' dim(sl_table)
#' head(dim(sl_table))
#'
#' #count significant hits
#' counts <- count_of_SL(sl_table)
#'
count_of_SL <-
function(x, significance = "fdr", threshold = 0.05, syn_lethal = "strong", ts_sl = TRUE){
  if(syn_lethal == "strong") syn_lethal_condition <- 2
  if(syn_lethal == "weak") syn_lethal_condition <- c("C", "Q", 2)
  if(syn_lethal == "query") syn_lethal_condition <- c("Q", 2)
  if(syn_lethal == "candidate") syn_lethal_condition <- c("C", 2)
  if(!(syn_lethal %in% c("strong", "weak", "query", "candidate"))){
    syn_lethal_condition <- 2
    warning("please give syn_lethal as strong, weak, query, or candidate. Defaulting to strong: symmetric replication of gene pairs.")
  }
  sl_index <- ifelse(ts_sl, 11, 12)
  if(significance == "holm"){
    sum((x[,sl_index] %in% syn_lethal_condition) & (as.numeric(x[,16])<threshold)) #SL interactions & Holm Sig
  } else if(significance == "fdr"){
    sum((x[,sl_index] %in% syn_lethal_condition) & (as.numeric(x[,17])<threshold)) #SL interactions & FDR Sig
  } else if(significance == "raw"){
    sum((x[,sl_index] %in% syn_lethal_condition) & (as.numeric(x[,15])<threshold)) #SL interactions & raw Sig
  } else if(significance == "none" | is.null(significance) | missing(significance) | is.na(significance)){
    sum(x[,sl_index] %in% syn_lethal_condition) #SL interactions without signficance
  } else if(significance %in% p.adjust.methods){
    sum((x[,sl_index] %in% syn_lethal_condition) & (p.adjust(as.numeric(x[,15]), method = significance)<threshold))#SL interactions & custom Sig adjust
  } else {
    warning("Please give a valid significance condition: none, raw, or a valid method for p.adjust()")
  }
}
