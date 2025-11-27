# EVR628_Wells_Repo
This repository contains contents related to the EVR 628 project.

# Class Project

## Description

Analysis of IATTC data set: Tuna and billfish EPO longline catch and effort aggregated by year, month, flag, 5°x5°

This project aims to analyze trends for the following fish types (Species): Albacore, Yellowfin, and Black Marlin.

- Generate 2024 catch summaries aggregated by species and country, including: 
  + Monthly Average Catch Weight.
  + Average Number of Fish Caught.
  
- Visualize:
  + The overall amount of catch caught in 2024 in the Eastern Pacific Ocean.

## Project Structure

- 'data/raw': Contains the .csv zip file and dataset ('PublicLLTunaBillfishMt.csv') as downloaded from IATTC website.
- `scripts/01_processing`: Contains cleaned (tidy/wrangled) version of selected data set.
- 'scripts/03_content': Contains scripts producing figures and map visualizations.
- **View final presentation [HERE](http://localhost:5171/#/title-slide)**

## About the Data
### Column (Variables)
  - date:   Date - Date (Year-Month; XXXX-XX-XX)
      Year:   Numeric - Year in which catch was reported.
      Month:  Numeric - Month in which catch is reported. (1-12)
  - Flag:   Character - Renamed to 'Country'; Abbreviation of country name.
  - LatC5:  Numeric   - Latitude
  - LonC5:  Numeric   - Longitude
  - Hooks:  Numeric   - Number of Hooks
  
  - [Spp]mt:  Numeric   - Weight of indicated species (metric tons)
  - [Spp]n:   Numeric   - Amount of Fish Caught (count)
  
  - Species (Fish Type) Code: Character 
      ALB = Albacore
      YFT = Yellowfin
      BLM = Black marlin
      
  - Flag Codes
      Standard ISO-3166 codes used by the IATTC in its documents and publications.
      For further information on those codes, see
      https://www.iattc.org/en-US/Data/Reference-codes
    

## Author

[Austin Wells: ajw272@miami.edu]

##  References
- The Inter-American Tropical Tuna Commission (IATTC) - Public Domain for Data Download (September 2025).
  (Septempber 2025). <https://www.iattc.org/en-US/Data/Public-domain>