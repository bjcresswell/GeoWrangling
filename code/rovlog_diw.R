# Script to wrangle, convert and export entire CSMP Master ROV site list

library(sp)
library(rgdal)
library(parzer)
library(readxl)
library(tidyverse)

getwd()

rovlog <- read_excel('data/ROV Field Log Master.xlsx', 1, trim_ws = TRUE)

rov_geo <- rovlog %>% 
  select(Trip, Reef, Site, R_site_code, LAT, LONG) %>% 
  #mutate(Trip = as.Date(Trip, '%m/%y', origin = "1900-01-01")) %>% 
  mutate_if(is_character, as_factor) %>% 
  distinct()



