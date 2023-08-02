## Basic script to create kml file from csv

#rm(list=ls())

# Load required libraries
library(sp)
library(sf)
library(rgdal)
library(readxl)
library(tidyverse)

# RECEIVERS

# Going to reach into the CSMP repo to get the list of receiver locations
receiver_locs <- read_excel("~/Library/CloudStorage/OneDrive-JamesCookUniversity/Ben PhD/Data & analysis/CSMPTaggedAnimals/data/receiver_list_dep1.xlsx", trim_ws = TRUE) %>%
  tibble() %>% # Make into tibble format
  mutate_if(is.character, as.factor) # Sort out variables

receiver_locs

vr2_sf = st_as_sf(receiver_locs, coords = c("station_longitude", "station_latitude"), crs = 4326) %>%  # Need to have correct CRS
  select(Name = station_name)  # Need to specify this

st_write(vr2_sf, "vr2w.kml", driver = "kml", delete_dsn = TRUE)
