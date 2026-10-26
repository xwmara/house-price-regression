# Data preparation shared by all report pages.

# Overall_Qual is an ordinal rating. A CSV does not keep factor level order,
# so the levels are set explicitly (worst to best).
QUAL_LEVELS <- c("Very_Poor", "Poor", "Fair", "Below_Average", "Average",
                 "Above_Average", "Good", "Very_Good", "Excellent",
                 "Very_Excellent")

# Read the data snapshot and restore the factor types used in the analysis.
read_ames <- function(file = file.path("data", "ames_housing.csv")) {
  if (!file.exists(file)) {
    stop(file, " not found. Run `Rscript R/make_data.R` from the project root first.")
  }
  ames <- read.csv(file)
  ames$Overall_Qual <- factor(ames$Overall_Qual, levels = QUAL_LEVELS)
  stopifnot(!anyNA(ames$Overall_Qual))
  # North_Ames, the neighborhood with the most sales, is the reference level
  # for the neighborhood dummies in the regression models.
  ames$Neighborhood <- relevel(factor(ames$Neighborhood), ref = "North_Ames")
  ames
}

# Keep the dependent variable and the nine candidate predictors, and add the
# variables used by the multiple regression: log price, log living area,
# log lot area and the 1-10 rank of overall quality.
select_model_vars <- function(ames) {
  ames |>
    select(
      Sale_Price,
      Gr_Liv_Area,
      Overall_Qual,
      Garage_Cars,
      Full_Bath,
      Bedroom_AbvGr,
      TotRms_AbvGrd,
      Lot_Area,
      Year_Built,
      Neighborhood
    ) |>
    mutate(
      ln_Sale_Price = log(Sale_Price),
      ln_Gr_Liv_Area = log(Gr_Liv_Area),
      ln_Lot_Area = log(Lot_Area),
      Overall_Qual_num = as.numeric(Overall_Qual)
    )
}

# Group neighborhoods with fewer than min_n sales in the training set into
# "Other". The rare levels are found on the training set only and the same
# grouping is applied to the test set, so no test information is used.
group_rare_neighborhoods <- function(train, test, min_n = 10) {
  counts <- table(train$Neighborhood)
  keep <- names(counts)[counts >= min_n]
  group <- function(x) {
    factor(ifelse(as.character(x) %in% keep, as.character(x), "Other"),
           levels = c(keep, "Other"))
  }
  list(
    train = mutate(train, Neighborhood_grp = group(Neighborhood)),
    test = mutate(test, Neighborhood_grp = group(Neighborhood)),
    rare = setdiff(levels(train$Neighborhood), keep)
  )
}

# 70/30 train/test split, stratified by log price so both sets cover the
# whole price range.
split_train_test <- function(houses, seed) {
  set.seed(seed)
  initial_split(houses, prop = 0.7, strata = ln_Sale_Price)
}
