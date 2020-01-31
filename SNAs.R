library(tidyverse)
library(rvest)
all_sna <- read_html("https://www.dnr.state.mn.us/snas/list.html") %>%
  html_nodes("table li a")

hit_api <- function(id)
{
  print(id)
  url <- paste0("http://maps1.dnr.state.mn.us/cgi-bin/compass/feature_detail.cgi?id=", id)
  out <- jsonlite::read_json(url)
  if(out$status != "SUCCESS") warning(id)
  Sys.sleep(1)
  out
}

id <- str_extract(html_attr(all_sna, "href"), "sna\\d+$")
dat <- map(id, hit_api)
dat2 <- map(dat, "result")
jsonlite::write_json(dat2, "snas.json", pretty = TRUE, auto_unbox = TRUE, na = "null")
