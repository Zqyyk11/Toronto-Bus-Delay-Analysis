#### Preamble ####
# Purpose: Downloads the raw bus delay data from Open Data Toronto for use 
#          in the analysis.
# Author: Charlie Zhang
# Date: 28th November 2024
# Contact: zqycharlie.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `opendatatoronto` and `tidyverse` packages must be installed.
# Any other information needed? Ensure an active internet connection and that the 
#          working directory is set to the project folder.

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

         
