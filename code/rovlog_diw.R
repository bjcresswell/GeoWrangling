# Script to wrangle, convert and export entire CSMP Master ROV site list

# Load Libraries
library(sp)
library(rgdal)
library(parzer)
library(readxl)
library(tidyverse)

getwd()

# Load data
rovlog <- read_excel('data/ROV Field Log Master.xlsx', 1, trim_ws = TRUE)

# Count number of distinct rows (gives one entry per site code plus lat and long)
rov_geo <- rovlog %>% 
  select(Trip, Reef, Site, R_site_code, LAT, LONG) %>% 
  #mutate(Trip = as.Date(Trip, '%m/%y', origin = "1900-01-01")) %>% 
  mutate_if(is_character, as_factor) %>% 
  distinct()

# Can save...


# And also convert into kml file for use in GIS

# Specify coordinate parameters 
coordinates(rov_geo) <- c("LONG", "LAT") # Need to relate to the correct columns in the df
proj4string(rov_geo) <- CRS("+init=epsg:4326")  # Apply the correct CRS - going to be EPSG 4326 for Australia/QLD/CS etc

# Create new object 
csmp_ROV_geo<- spTransform(rov_geo, CRS("+proj=longlat +datum=WGS84"))

# And export
writeOGR(csmp_ROV_geo["R_site_code"], "output/csmp_ROV_sites.kml", layer="R_site_code", driver="KML") 
