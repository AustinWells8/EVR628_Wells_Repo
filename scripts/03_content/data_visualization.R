################################################################################
# Assignment #3 - Visualizing Your Data
################################################################################
#
# Austin Wells
# ajw272@miami.edu
# October 19, 2025
#
# Description: Creating 2 visualization plots
# 
#
################################################################################


# Load Packages -----------------------------------------------------------

library(EVR628tools)
library(tidyverse)
library(dplyr)
library(janitor)
library(lubridate)

library(cowplot)

# Loading Data ------------------------------------------------------------
tuna_and_billfish <- read_csv("data/raw/PublicLLTunaBillfishMt.csv")


# Build Data for Use ------------------------------------------------------

##  Cleaning/ Wrangling Data set to provide the average catch weight (mt) of by month & country
##  for the 3 selected Species (Albacore = ALB, Yellowfin = YFT, & Black Marlin = BLM) in the year 2024.
tuna_and_billfish <- read_csv("data/raw/PublicLLTunaBillfishMt.csv")|>
  rename(Country = Flag) |>
  mutate(date = make_date(year = Year, month = Month, day = 1)) |>
  mutate(date = format(date, "%Y-%m"))

target_tuna_and_billfish <- tuna_and_billfish |> 
  select(date, Country, LonC5, LatC5, Hooks, ALBmt, YFTmt, BLMmt) |>
  filter(ALBmt > 0, YFTmt > 0, BLMmt > 0,
         date >= 2024) |>
  group_by(date, Country) |>
  pivot_longer(cols = c(ALBmt, YFTmt, BLMmt), ## Using Pivot Longer function so fish type (species) can be in 1 column.
               names_to = "Species",
               values_to = "Catch_mt")

avg_monthly_fish_wt <- target_tuna_and_billfish |>
  group_by(date, Country, Species) |>
  summarise(avg_catch_mt = mean(Catch_mt, na.rm = TRUE))

unique(avg_monthly_fish_wt$Country)

# Create Your Plot --------------------------------------------------------

##  Figure 1. Creating a line graph of the Avg Catch Weight (mt) over time for 3 fish species
##  for each Country.

ggplot(data = avg_monthly_fish_wt,
       aes(x = date, y = avg_catch_mt, color = Species)) +
  geom_point(size = 1) +
  facet_wrap(~Country, ncol = 1, scales = "free_y") +
  labs(
    title = "Monthly Average Catch Weight in 2024",
    subtitle = "By Species and Country",
    x = "Date (Month)", y = "Average Catch Weight (mt)") +
  theme_minimal(base_size = 14)

##  Figure 2. Creating a bar chart of the # of Hooks used in 2024 by Species and Country.

ggplot(data = target_tuna_and_billfish,
       mapping = aes(x = Hooks, y = Species)) + 
  facet_wrap(~Country, ncol = 1) + 
  geom_col() +
  labs(title = "Number of Hooks Used in 2024",
       subtitle = "by Species and Country",
       x = " Number of Hooks (Usage)",
       y = "Species") +
  theme_minimal(base_size = 14)

###### REMEMBER TO SAVE PLOTS as (.png) END EXPORT TO results/img folder !!!!
