## Basic script to convert degrees and decimal minutes into decimal degrees

# Load required libraries
library(parzer)
library(readxl)
library(tidyverse)

# Load data
ROV_lat_conv <- read_excel("data/ROV_lat_conv.xlsx")

# Convert lats and longs
ROV_dec<- ROV_lat_conv %>%                    # create an entirely new df 
  mutate(Site_Wpt = factor(paste(Site, Wpt)), # new column with unique ID - may not be required
         Dec_lat = parse_lat(latitude),       # parse_lat and long convert the values
         Dec_lon = parse_lon(longitud)) %>%   # can either replace the old values or add new ones
  select(Site_Wpt, Dec_lat, Dec_lon)          # select only columns of interest.


# And save if required
write_csv(ROV_dec, file = "../../ROV_ll_dec.csv")

# Turtle islands data for G

turtles <- read_csv("data/TURTLES_SITES_2024.csv")

# Convert lats and longs
turtles2 <- turtles %>%                    # create an entirely new df 
  mutate(Dec_lat = parse_lat(LAT),       # parse_lat and long convert the values
         Dec_lon = parse_lon(LONG)) 

# And save if required
write_csv(turtles2, file = "output/TURTLES_SITES_2024_DECI.csv")

