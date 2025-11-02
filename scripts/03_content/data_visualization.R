################################################################################
# Assignment #3 - Visualizing Your Data
################################################################################
#
# Austin Wells
# ajw272@miami.edu
# October 19, 2025
#
# Description: Creating 2 visualization plots:
# 1. Monthly Average Catch Weight in 2024 by Species and Country.
# 2. Average Number of Fish Caught per Month by Species and Country in 2024.
# 
################################################################################


# Load Packages -----------------------------------------------------------

library(EVR628tools)
library(tidyverse)
library(dplyr)
library(janitor)
library(lubridate)

library(cowplot)
library(ggridges)

# Loading Data ------------------------------------------------------------
tuna_and_billfish_mt <- read_csv("data/raw/PublicLLTunaBillfishMt.csv")

tuna_and_billfish_num <- read_csv("data/raw/PublicLLTunaBillfishNum.csv")

# Build Data for Use ------------------------------------------------------

##  Cleaning/ Wrangling Data set to provide the average catch weight (mt) & amount (n) of by month & country
##  for the 3 selected Species (Albacore = ALB, Yellowfin = YFT, & Black Marlin = BLM) in the year 2024.
tuna_and_billfish_mt <- read_csv("data/raw/PublicLLTunaBillfishMt.csv")|>
  rename(Country = Flag) |>
  mutate(date = make_date(year = Year, month = Month, day = 1))

tuna_and_billfish_num <- read_csv("data/raw/PublicLLTunaBillfishNum.csv")|>
  rename(Country = Flag) |>
  mutate(date = make_date(year = Year, month = Month, day = 1))


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

avg_monthly_fish_wt <- target_fish_mt |>
  group_by(date, Country, `Fish Weight`) |>
  summarise(avg_catch_mt = mean(Catch_mt, na.rm = TRUE))

avg_monthly_fish_num <- target_fish_num |>
  group_by(date, Country, `Fish Amount`) |>
  summarise(avg_catch_num = mean(Catch_num, na.rm = TRUE))


# Create Your Plot --------------------------------------------------------

##  Figure 1. Creating a line graph of the Avg Catch Weight (mt) over time for 3 fish species
##  for each Country.

p1 <- ggplot(data = avg_monthly_fish_wt,
       aes(x = date, y= avg_catch_mt, color = `Fish Weight`)) +
  geom_line(size = 1, linewidth = 0.5) +
  geom_point(size = 1) +
  scale_color_discrete(labels = c("ALBmt" = "Albacore Tuna", "YFTmt" = "Yellowfin Tuna", "BLMmt" = "Black Marlin")) +
  facet_wrap(~Country, ncol = 1, scales = "free_y") +
  labs(
    title = "Monthly Average Catch Weight in 2024",
    subtitle = "By Species and Country",
    x = "Date (Month)", y = "Average Catch Weight (mt)",
    caption = "Data source: IATTC Dataset - Tuna and Billfish EPO longline catch and effort") +
  theme_minimal(base_size = 14)

##  Figure 2. Creating a bar chart of the Average Amount of Fish Caught for 3 fish species
##  by country for the year 2024. 

p2 <- ggplot(data = avg_monthly_fish_num,
       aes(x = date, y = avg_catch_num, fill = `Fish Amount`)) +
  geom_col(position = "dodge", alpha = 1) +
  facet_wrap(~Country, scales = "free", ncol = 1) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  labs(title = "Average Number of Fish Caught",
       subtitle = "BySpecies and Country",
       x = "Date (Month)",
       y = "Average Amount of Catch",
       caption = "Data source: IATTC Dataset - Tuna and Billfish EPO longline catch and effort") +
  scale_fill_discrete(name = "Fish Type",
                    labels = c("ALBn" = "Albacore Tuna", "YFTn" = "Yellowfin Tuna", "BLMn" = "Black Marlin")) +
  theme_minimal()

my_plot <- plot_grid(p1,p2,
                     ncol = 2,
                     labels = c("A)", "B)"))

# EXPORT ------------------------------------------------------------------
ggsave(plot = my_plot,
       filename = "results/img/avg_catch_wt_and_catch_amount.png", 
       width = 10,
       height = 10)

