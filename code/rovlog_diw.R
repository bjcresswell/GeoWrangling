# Script to wrangle, convert and export entire CSMP Master ROV site list to kml file for use in GIS
# Created: 16 May 2022 BJC

# Load Libraries
library(sp)
library(zoo)
library(rgdal)
library(parzer)
library(readxl)
library(tidyverse)

getwd()

# Load data
rovlog <- read_excel('data/ROV Field Log Master.xlsx', 1, trim_ws = TRUE)

glimpse(rovlog) # Has multiple entries per site code - we can condense this down using..

# distinct rows (gives one entry per site code plus lat and long)
rov_geo <- rovlog %>% 
  select(Trip, Reef, Site, R_site_code, LAT, LONG) %>%               # simplify df by keeping in only columns required
  mutate(Trip = zoo::as.yearmon(Trip)) %>%                           # sort the trip column out (not that necessary but did it anyway)
  mutate_if(is_character, as_factor) %>%                             # sort out chr to fct
  distinct()

# Can save...



# And also convert into kml file for use in GIS in either sf or sp (sf works better)

# 1.  In sf
## More info here: https://stackoverflow.com/questions/57415464/label-kml-features-using-st-write
csmp_sf = st_as_sf(rov_geo, coords = c("LONG", "LAT"), crs = 4326) %>%  # Need to have correct CRS
  select(Name = R_site_code)  # Need to specify this
  
st_write(csmp_sf, "output/csmprov.kml", driver = "kml", delete_dsn = TRUE)



# 2.  In sp (have NOT been able to get site names to convert properly so that they'll show up in the side bar of Google Earth)
## More info here: https://stackoverflow.com/questions/7813141/how-to-create-a-kml-file-using-r
# Select columns of interest
rov_geo2 <- rov_geo %>% 
  select(R_site_code, Reef, LAT, LONG)

# Specify coordinate parameters 
coordinates(rov_geo2) <- c("LONG", "LAT") # Need to relate to the correct columns in the df
proj4string(rov_geo2) <- CRS("+init=epsg:4326")  # Apply the correct CRS - going to be EPSG 4326 for Australia/QLD/CS etc

# Create new object 
csmp_ROV_geo<- spTransform(rov_geo2, CRS("+proj=longlat +datum=WGS84"))

# And export
writeOGR(csmp_ROV_geo["R_site_code"], "output/csmp_ROV_sites.kml", layer="R_site_code", driver="KML", delete_dsn = TRUE) 
