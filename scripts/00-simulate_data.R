#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(dplyr)
library(lubridate)

#### Define Simulation Parameters ####
set.seed(397)  # For reproducibility

# Number of simulated records
n <- 10000

# Define variables
routes <- paste("Route", sample(1:100, 20, replace = TRUE))  # Random route names
stops <- paste("Stop", sample(1:500, 50, replace = TRUE))    # Random stop names
causes <- c("Mechanical", "Traffic", "Weather", "Collision", "Other")
locations <- paste("Location", sample(1:200, 20, replace = TRUE))  # Random locations

# Generate random delay durations based on cause
generate_delay <- function(cause) {
  case_when(
    cause == "Mechanical" ~ abs(rnorm(1, mean = 15, sd = 5)),  # Avg 15 min
    cause == "Traffic" ~ abs(rnorm(1, mean = 10, sd = 3)),     # Avg 10 min
    cause == "Weather" ~ abs(rnorm(1, mean = 20, sd = 7)),     # Avg 20 min
    cause == "Collision" ~ abs(rnorm(1, mean = 25, sd = 10)),  # Avg 25 min
    TRUE ~ abs(rnorm(1, mean = 5, sd = 2))                     # Other causes
  )
}

#### Generate Simulated Data ####
simulated_data <- tibble(
  Date = sample(seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day"), n, replace = TRUE),
  Time = hms::hms(hour = sample(0:23, n, replace = TRUE), 
                  minute = sample(0:59, n, replace = TRUE)),
  Route = sample(routes, n, replace = TRUE),
  Stop = sample(stops, n, replace = TRUE),
  Delay_Cause = sample(causes, n, replace = TRUE, prob = c(0.3, 0.4, 0.1, 0.1, 0.1)),  # Weighted probabilities
  Delay_Minutes = sapply(sample(causes, n, replace = TRUE), generate_delay),
  Location = sample(locations, n, replace = TRUE)
)

#### Post-Processing ####
# Round delay minutes to nearest integer
simulated_data <- simulated_data %>% 
  mutate(Delay_Minutes = round(Delay_Minutes, 0))

# Sort by date and time for realism
simulated_data <- simulated_data %>% arrange(Date, Time)

#### Inspect the Simulated Data ####
head(simulated_data)

#### Save the Simulated Dataset ####
write.csv(simulated_data, "data/00-simulated_data/simulated_ttc_bus_delay_data.csv", row.names = FALSE)

