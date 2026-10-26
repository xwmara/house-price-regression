# Shared setup sourced at the top of every report page: packages, plot theme,
# the random seed, and the prepared data with its train/test split.

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(rsample)
})

theme_set(theme_bw())

# One seed for every random step (train/test split, K-Means, cross-validation)
SEED <- 123

# Formatting helpers for numbers written in the report text (inline R)
fmt_num <- function(x, digits = 0) {
  formatC(x, format = "f", digits = digits, big.mark = ",")
}
fmt_usd <- function(x, digits = 0) paste0("$", fmt_num(x, digits))
fmt_pct <- function(x, digits = 1) paste0(fmt_num(100 * x, digits), "%")

# Sample skewness: 0 for a symmetric distribution, > 0 for a long right tail
skewness <- function(x) mean(((x - mean(x)) / sd(x))^3)

source(file.path("R", "prepare_data.R"))

ames <- read_ames()
houses <- select_model_vars(ames)

data_split <- split_train_test(houses, seed = SEED)
train <- training(data_split)
test <- testing(data_split)
