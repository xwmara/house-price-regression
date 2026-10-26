# Data

## `ames_housing.csv`

Residential property sales in Ames, Iowa, 2006–2010: 2,930 sales and 81 columns.

The file is a snapshot of `AmesHousing::make_ames()` (AmesHousing 0.0.4),
written by [`R/make_data.R`](../R/make_data.R). To rebuild it, run this from
the project root:

```sh
Rscript R/make_data.R
```

### Processing done by `make_ames()`

The original data (`AmesHousing::ames_raw`) were cleaned by the package
author. The main changes are listed below; the package documentation has the
full list.

- Column names are in snake case (for example, `SalePrice` became `Sale_Price`).
- Factor levels have readable labels (for example, `Above_Average` instead of `6`).
- Missing values that mean "feature not present" were recoded. For example,
  a house with no basement has `Bsmt_Qual = No_Basement` and
  `Total_Bsmt_SF = 0`.
- `PID`, `Order` and `Garage_Yr_Blt` were removed.
- Approximate `Longitude` and `Latitude` were added.

### Reading the CSV

A CSV does not store factor level order. `Overall_Qual` is an ordinal rating,
so set its levels explicitly when reading the file. Otherwise R sorts them
alphabetically and converting them to numbers gives the wrong scale:

```r
qual_levels <- c("Very_Poor", "Poor", "Fair", "Below_Average", "Average",
                 "Above_Average", "Good", "Very_Good", "Excellent",
                 "Very_Excellent")
ames$Overall_Qual <- factor(ames$Overall_Qual, levels = qual_levels)
```

## Variables used in the analysis

| Variable | Description | Unit |
|---|---|---|
| `Sale_Price` | Sale price (dependent variable) | US dollars |
| `Gr_Liv_Area` | Above-ground living area | square feet |
| `Overall_Qual` | Overall material and finish quality, rated by the assessor | ordinal, 10 levels (`Very_Poor` to `Very_Excellent`) |
| `Garage_Cars` | Garage capacity | number of cars |
| `Full_Bath` | Full bathrooms above ground | count |
| `Bedroom_AbvGr` | Bedrooms above ground | count |
| `TotRms_AbvGrd` | Total rooms above ground, excluding bathrooms | count |
| `Lot_Area` | Lot size | square feet |
| `Year_Built` | Original construction year | year |
| `Neighborhood` | Neighborhood within Ames city limits | categorical |

The data are cross-sectional: each row is one sale. The other columns are
described in the AmesHousing documentation (`?AmesHousing::ames_raw`).

## Source and terms of use

- **Original data:** Dean De Cock compiled the data from the Ames City
  Assessor's Office and published them with the paper below.
- **Distribution used here:** the
  [AmesHousing](https://CRAN.R-project.org/package=AmesHousing) R package by
  Max Kuhn, released under the GPL-2 license. The CSV is redistributed here
  under the same terms, with the citations below.
- The paper itself is copyrighted by its author. It is cited here but not
  included in this repository.

### Citation

> De Cock, D. (2011). Ames, Iowa: Alternative to the Boston Housing Data as an
> End of Semester Regression Project. *Journal of Statistics Education*, 19(3).
> https://doi.org/10.1080/10691898.2011.11889627

> Kuhn, M. (2020). *AmesHousing: The Ames Iowa Housing Data*. R package
> version 0.0.4. https://doi.org/10.32614/CRAN.package.AmesHousing
