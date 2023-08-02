library(gpx)

gpx_file <- list.files(path = "data/GPX",	pattern = "*.gpx", full.names = TRUE) %>%
  lapply(read_gpx) %>%
  map_dfr(as_tibble, .name_repair = "universal")
