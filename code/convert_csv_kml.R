## Basic script to create kml file from csv

# Load required libraries
library(sp)
library(rgdal)

# Load data 
# In this case I am using the output file from the decimal_degree_conversion.R file

# Specify coordinate parameters 
coordinates(ROV_dec) <- c("Dec_lon", "Dec_lat") # Need to relate to the correct columns in the df
proj4string(ROV_dec) <- CRS("+init=epsg:4326")  # Apply the correct CRS - going to be EPSG 4326 for Australia/QLD/CS etc

# Create new object 
ROV_dec_ll <- spTransform(ROV_dec, CRS("+proj=longlat +datum=WGS84"))

# And export
writeOGR(ROV_dec_ll["Site_Wpt"], "my.kml", layer="Site_Wpt", driver="KML") 