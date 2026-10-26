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

source(file.path("R", "prepare_data.R"))

ames <- read_ames()
houses <- select_model_vars(ames)

data_split <- split_train_test(houses, seed = SEED)
train <- training(data_split)
test <- testing(data_split)
