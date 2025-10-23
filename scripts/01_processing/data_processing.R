################################################################################
# Assignment #2: Data Wrangling
################################################################################
#
# Austin Wells
# ajw272@miami.edu
# October 19, 2025
#
# Description
# Analysis of IATTC Dataset - Tuna and Billfish EPO longline catch and effort
# aggregated by year, month, flag (Country).
################################################################################

# Load Packages -----------------------------------------------------------

library(EVR628tools)
library(tidyverse)
library(dplyr)
library(janitor)
library(lubridate)

# Load Data ---------------------------------------------------------------

tuna_and_billfish <- read_csv("data/raw/PublicLLTunaBillfishMt.csv")

colnames(tuna_and_billfish)

# Building The Data for Use -----------------------------------------------
## Create single column called 'date' (XXXX-XX). Combining the Year and Month.
tuna_and_billfish <- read_csv("data/raw/PublicLLTunaBillfishMt.csv")|>
  rename(Country = Flag) |>
  mutate(date = make_date(year = Year, month = Month, day = 1)) |>
  mutate(date = format(date, "%Y-%m"))

## Filter data to only represent fish of choice:
## (Albacore = ALB, Yellowfin = YFT, & Black Marlin = BLM)
## This analysis will include data from year 2000 and on.

target_tuna_and_billfish <- tuna_and_billfish |> 
  select(date, Country, LonC5, LatC5, Hooks, ALBmt, YFTmt, BLMmt) |>
  filter(ALBmt > 0, YFTmt > 0, BLMmt > 0,
         date >= 2000) |>
  group_by(date, Country) |>
  pivot_longer(cols = c(ALBmt, YFTmt, BLMmt), ## Using Pivot Longer function so fish type (species) can be in 1 column.
               names_to = "Species",
               values_to = "Catch_mt")

glimpse(target_tuna_and_billfish)


## Framing data to provide monthly Average Weight (mt) of catch species, country, and date.
avg_monthly_fish_wt <- target_tuna_and_billfish |>
  group_by(date, Country, Species) |>
  summarise(avg_catch_mt = mean(Catch_mt, na.rm = TRUE))

write_rds(avg_monthly_fish_wt, file = "data/processed/avg_monthly_fish_wt.rds")
