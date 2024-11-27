#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Australian 
  #electoral divisions dataset.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
#### Load Required Libraries ####
library(dplyr)

#### Load the Simulated Dataset ####
file_path <- "data/00-simulated_data/simulated_ttc_bus_delay_data.csv"  
simulated_data <- read.csv(file_path)

#### Define Testing Functions ####

# Function to assert a condition
assert <- function(condition, message) {
  if (!condition) stop(message)
}

#### Tests ####

# Test 1: Check if dataset is loaded successfully
assert(!is.null(simulated_data), "Dataset failed to load.")
assert(nrow(simulated_data) > 0, "Dataset has no rows.")
assert(ncol(simulated_data) > 0, "Dataset has no columns.")

# Test 2: Check if all required columns are present
required_columns <- c("Date", "Time", "Route", "Stop", "Delay_Minutes", "Delay_Cause", "Location")
missing_columns <- setdiff(required_columns, names(simulated_data))
assert(length(missing_columns) == 0, paste("Missing required columns:", paste(missing_columns, collapse = ", ")))

# Test 3: Check for valid data types in key columns
assert(is.character(simulated_data$Date), "Date column is not of type character.")
assert(is.character(simulated_data$Time), "Time column is not of type character.")
assert(is.numeric(simulated_data$Delay_Minutes), "Delay_Minutes column is not numeric.")
assert(is.character(simulated_data$Delay_Cause), "Delay_Cause column is not of type character.")

# Test 4: Ensure no missing or invalid values in critical columns
assert(!any(is.na(simulated_data$Date)), "Date column contains missing values.")
assert(!any(is.na(simulated_data$Time)), "Time column contains missing values.")
assert(!any(is.na(simulated_data$Delay_Minutes)), "Delay_Minutes column contains missing values.")
assert(!any(is.na(simulated_data$Delay_Cause)), "Delay_Cause column contains missing values.")
assert(all(simulated_data$Delay_Minutes >= 0), "Delay_Minutes contains non-positive values.")

# Test 5: Check that delay durations are within a realistic range
assert(all(simulated_data$Delay_Minutes <= 120), "Delay_Minutes contains values greater than 120.")

# Test 6: Ensure no duplicate rows (optional)
assert(nrow(simulated_data) == nrow(unique(simulated_data)), "Dataset contains duplicate rows.")

#### Print Test Results ####
print("All tests passed successfully!")

