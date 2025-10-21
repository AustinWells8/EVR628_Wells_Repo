# EVR628_Wells_Repo
This repository contains contents related to the EVR 628 project.

# Class Project

## Description

Analysis of IATTC data set: Tuna and billfish EPO longline catch and effort aggregated by year, month, flag, 5°x5°

## Project Structure

- 'data/raw/': Contains the .csv zip file and dataset ('PublicLLTunaBillfishMt.csv') as downloaded from IATTC website.
- `scripts/01_processing`: Contains cleaned (tidy/wrangled) version of selcted data set.

## About the Data
### Column (Variables)
  - Year: Numeric - Year in which catach was reported.
  - Month: Numeric - Month in which catch is reported. (1-12)
  - Flag: Character - Renamed to 'Country'; Abbreviation of country name.
  - Species (Fish Type): Character - Abbreviated name of fish type.; Values represent fish weight (metric tons).
    

## Author

[Austin Wells: ajw272@miami.edu]