# Regenerates data/ames_housing.csv from the AmesHousing package.
#
# The CSV is a snapshot of AmesHousing::make_ames(), the processed version of
# the De Cock (2011) data. The report reads the CSV, so it does not depend on
# this script; run it only to rebuild the snapshot.
# Run from the project root: Rscript R/make_data.R

library(AmesHousing)

ames <- make_ames()

write.csv(ames, file.path("data", "ames_housing.csv"), row.names = FALSE)

message("Wrote ", nrow(ames), " rows and ", ncol(ames),
        " columns to data/ames_housing.csv")
