################################################################################
# Assignment #4 - Visualizing Spatial Data
################################################################################
#
# Austin Wells
# ajw272@miami.edu
# November 16, 2025
#
# Description
#
################################################################################


# Loading Packages --------------------------------------------------------
library(EVR628tools)   # For fishing effort data and color palettes
library(ggspatial)     # To add map elements to a ggplot
library(rnaturalearth) # To add country outlines
library(tidyverse)     # General data wrangling
library(sf)            # Working with vector data
library(terra)         # Working with raster data
library(tidyterra)     # Working with raster data in tidy approach
library(mapview)       # To quickly inspect data


# Loading Data ------------------------------------------------------------

tuna_and_billfish_num <- read_csv("data/raw/PublicLLTunaBillfishNum.csv")|>
  rename(Country = Flag) |>
  mutate(date = make_date(year = Year, month = Month, day = 1))

target_fish_num <- tuna_and_billfish_num |> 
  select(date, Country, LonC5, LatC5, Hooks, ALBn, YFTn, BLMn) |>
  filter(ALBn > 0, YFTn > 0, BLMn > 0,
         date >= "2024-01-01") |>
  group_by(date, Country) |>
  pivot_longer(cols = c(ALBn, YFTn, BLMn), ## Using Pivot Longer function so fish type (species) can be in 1 column.
               names_to = "Fish Amount",
               values_to = "Catch_num")

# Building Data for Use ---------------------------------------------------
##  Converting data to sf
target_fish_sf <- target_fish_num |>
  st_as_sf(coords = c("LonC5", "LatC5"), crs=4326, remove = FALSE)

##  Coverting to Vector
target_fish_vector <- vect(target_fish_sf)

## Setting up Plot
r_template <- rast(ext(target_fish_vector), resolution = 1, crs = "EPSG:4326")

##  Rasterizing; For each species type
### Albacore (ALB)
alb_vect <- target_fish_vector[target_fish_vector$`Fish Amount`== "ALBn"]
alb_rast <- rasterize(alb_vect, r_template, field = "Catch_num", fun = "sum")

### YELLOWFIN
yft_vect <- target_fish_vector[target_fish_vector$`Fish Amount`== "YFTn"]
yft_raster <- rasterize(yft_vect, r_template, field = "Catch_num", fun = "sum")

### BLACK MARLIN
blm_vect <- target_fish_vector[target_fish_vector$`Fish Amount`== "BLMn"]
blm_raster <- rasterize(blm_vect, r_template, field = "Catch_num", fun = "sum")

##  Defining Map Features/ Attributes

world <- ne_countries(scale = "medium", returnclass = "sf")
countries <- ne_countries(
  scale = "medium",
  country = c("China", "Japan", "Korea",
              "Panama", "French Polynesia",
              "Chinese Taipei", "Vanuatu"),
  returnclass = "sf")

# Building Map - For Species of Interest (ALB, YFT, BLM) ------------------
## Using geom_spatraster()

ALBmap1 <- ggplot() +
  geom_sf(data = world, fill = "gray90", color = "black") +
  geom_spatraster(data = alb_rast) +
  scale_fill_viridis_c(name = "Albacore Catch (num)", option = "magma", na.value = "transparent") + # Modifying scale title and color
  coord_sf(xlim = c(100, -140), ylim = c(-40, 60), expand = FALSE) + # Zooming in on map
  annotation_north_arrow(location = "tr") + #Adding in North Arrow
  annotation_scale(location = "br") + #Adding scale bar
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(
    title = "Albacore Catch in 2024",
    subtitle = "Heat map of overall amount of Albacore caught in E. Pacific in 2024",
    x = "Longitude",
    y = "Latitude",
    caption = "Source: IATTC Dataset - Tuna and Billfish EPO Longline Catch and Effort") + # Figure Labels
  theme_minimal(base_size = 14)
ALBmap1

YFTmap1 <- ggplot() +
   geom_sf(data = world, fill = "gray90", color = "black") +
   geom_spatraster(data = yft_raster) +
   scale_fill_viridis_c(name = "Albacore Catch (num)", option = "magma", na.value = "transparent") + # Modifying scale title and color
   coord_sf(xlim = c(100, -140), ylim = c(-40, 60), expand = FALSE) + # Zooming in on map
   annotation_north_arrow(location = "tr") + #Adding in North Arrow
   annotation_scale(location = "br") + #Adding scale bar
   scale_x_continuous(expand = c(0, 0)) +
   scale_y_continuous(expand = c(0, 0)) +
   labs(
     title = "Yellowfin Catch in 2024",
     subtitle = "Heat map of overall amount of Yellowfin caught in E. Pacific in 2024",
     x = "Longitude",
     y = "Latitude",
     caption = "Source: IATTC Dataset - Tuna and Billfish EPO Longline Catch and Effort") + # Figure Labels
   theme_minimal(base_size = 14)
YFTmap1

BLMmap1 <- ggplot() +
  geom_sf(data = world, fill = "gray90", color = "black") +
  geom_spatraster(data = blm_raster) +
  scale_fill_viridis_c(name = "Albacore Catch (num)", option = "magma", na.value = "transparent") + # Modifying scale title and color
  coord_sf(xlim = c(100, -140), ylim = c(-40, 60), expand = FALSE) + # Zooming in on map
  annotation_north_arrow(location = "tr") + #Adding in North Arrow
  annotation_scale(location = "br") + #Adding scale bar
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(
    title = "Black Marlin Catch in 2024",
    subtitle = "Heat map of overall amount of Black Marlin caught in E. Pacific in 2024",
    x = "Longitude",
    y = "Latitude",
    caption = "Source: IATTC Dataset - Tuna and Billfish EPO Longline Catch and Effort") + # Figure Labels
  theme_minimal(base_size = 14)
BLMmap1

# EXPORT ------------------------------------------------------------------
ggsave(ALBmap1, filename = "results/img/albmap1.png", width = 10, height = 10)
ggsave(YFTmap1, filename = "results/img/yftmap1.png", width = 10, height = 10)
ggsave(BLMmap1, filename = "results/img/blmmap1.png", width = 10, height = 10)