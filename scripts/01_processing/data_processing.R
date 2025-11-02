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

tuna_and_billfish_mt <- read_csv("data/raw/PublicLLTunaBillfishMt.csv")

tuna_and_billfish_num <- read_csv("data/raw/PublicLLTunaBillfishNum.csv")

# Building The Data for Use -----------------------------------------------
## Create single column called 'date' (XXXX-XX-XX). Combining the Year and Month.
tuna_and_billfish_mt <- read_csv("data/raw/PublicLLTunaBillfishMt.csv")|>
  rename(Country = Flag) |>
  mutate(date = make_date(year = Year, month = Month, day = 1))

tuna_and_billfish_num <- read_csv("data/raw/PublicLLTunaBillfishNum.csv")|>
  rename(Country = Flag) |>
  mutate(date = make_date(year = Year, month = Month, day = 1))


## Filter data to only represent fish of choice:
## (Albacore = ALB, Yellowfin = YFT, & Black Marlin = BLM)
## This analysis will include data for the year 2024.

target_fish_mt <- tuna_and_billfish_mt |> 
  select(date, Country, LonC5, LatC5, Hooks, ALBmt, YFTmt, BLMmt) |>
  filter(ALBmt > 0, YFTmt > 0, BLMmt > 0,
         date >= "2024-01-01") |>
  group_by(date, Country) |>
  pivot_longer(cols = c(ALBmt, YFTmt, BLMmt), ## Using Pivot Longer function so fish type (species) can be in 1 column.
               names_to = "Fish Weight",
               values_to = "Catch_mt")

target_fish_num <- tuna_and_billfish_num |> 
  select(date, Country, LonC5, LatC5, Hooks, ALBn, YFTn, BLMn) |>
  filter(ALBn > 0, YFTn > 0, BLMn > 0,
         date >= "2024-01-01") |>
  group_by(date, Country) |>
  pivot_longer(cols = c(ALBn, YFTn, BLMn), ## Using Pivot Longer function so fish type (species) can be in 1 column.
               names_to = "Fish Amount",
               values_to = "Catch_num")

## Framing data to provide monthly Average Weight (mt) & Fish Amount (num) of catch species by country, and date (month).
avg_monthly_fish_wt <- target_fish_mt |>
  group_by(date, Country, `Fish Weight`) |>
  summarise(avg_catch_mt = mean(Catch_mt, na.rm = TRUE))

avg_monthly_fish_num <- target_fish_num |>
  group_by(date, Country, `Fish Amount`) |>
  summarise(avg_catch_num = mean(Catch_num, na.rm = TRUE))

write_rds(avg_catch_wt_and_catch_amount, file = "avg_catch_wt_and_catch_amount.rds")
