#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(dplyr)

#### Download data ####
# get package
package <- show_package("e271cdae-8788-4980-96ce-6a5c95bc6618")
package

# List the resources available in this package
resources <- list_package_resources(package)

# View the names and formats of the resources
resource_id <- resources %>%
  filter(name == "ttc-bus-delay-data-2023", format == "XLSX") %>%
  pull(id)

# Download the Excel file and save it to the raw_data folder
bus_delay_raw_data <- get_resource(resource_id)

#### Save data ####
# change the_raw_data to whatever name you assigned when you downloaded it.
write.csv(bus_delay_raw_data, "data/01-raw_data/bus_delay_raw_data_2023.csv", row.names = FALSE)

         
