#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
# Install and load required libraries
library(testthat)
library(dplyr)

bus_delay_data <- read.csv(here::here('data/02-analysis_data/bus_delay_clean_data_2023.csv'))


#### Test cases ####
### 1. Test for Missing Values ###
test_that("No missing values in critical columns", {
  expect_true(all(!is.na(bus_delay_data$min_delay)), info = "min_delay column has missing values")
  expect_true(all(!is.na(bus_delay_data$location)), info = "location column has missing values")
  expect_true(all(!is.na(bus_delay_data$incident)), info = "incident column has missing values")
})

### 2. Test for Data Type Validity ###
test_that("Data types are correct", {
  expect_type(bus_delay_data$date, "character") # Dates should be stored as character or Date
  expect_type(bus_delay_data$min_delay, "integer") # Delay should be numeric
  expect_type(bus_delay_data$route, "integer") # Route should be character
  expect_type(bus_delay_data$incident, "character") # Incident should be character
})

### 3. Test for Logical Value Ranges ###
test_that("Numeric columns have logical ranges", {
  expect_true(all(bus_delay_data$min_delay >= 0), info = "min_delay contains negative values")
  expect_true(all(bus_delay_data$min_gap >= 0), info = "min_gap contains negative values")
  expect_true(all(bus_delay_data$hour >= 0 & bus_delay_data$hour <= 23), info = "hour column has invalid values")
})

### 4. Test for Unique and Expected Values ###
test_that("Categorical columns have expected levels", {
  # Define the expected levels for 'day'
  expected_days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  
  # Check that all values in 'day' are in the expected set
  expect_true(all(bus_delay_data$day %in% expected_days), info = "Unexpected day values found in the data")
  
  # Optionally, ensure all expected days are represented in the dataset
  expect_true(all(expected_days %in% bus_delay_data$day), info = "Not all expected days are represented in the data")
})

### 5. Test for Duplicates ###
test_that("No duplicate rows exist", {
  expect_true(nrow(bus_delay_data) == nrow(distinct(bus_delay_data)), info = "Dataset contains duplicate rows")
})

### 6. Test for Missing Categories ###
test_that("All expected delay categories are present", {
  expected_delay_categories <- c("Short", "Moderate", "Long")
  
  if (!setequal(unique(bus_delay_data$delay_category), expected_delay_categories)) {
    fail("Missing or unexpected delay categories found in the data")
  }
  
  expect_setequal(unique(bus_delay_data$delay_category), expected_delay_categories)
})

### 7. Test for Logical Relationships ###
test_that("Delays correspond logically to incidents", {
  expect_true(all(bus_delay_data$min_delay > 0 | bus_delay_data$incident == "Not Specified"), 
              info = "Incidents without delays are not logically valid")
})

### 8. Test for Outliers in Delay ###
test_that("No unreasonable outliers in min_delay", {
  max_reasonable_delay <- 1000  # Define a maximum reasonable delay
  unreasonable_delays <- bus_delay_data$min_delay[bus_delay_data$min_delay > max_reasonable_delay]
  
  if (length(unreasonable_delays) > 0) {
    fail(paste("Unreasonably large delays found:", paste(unreasonable_delays, collapse = ", ")))
  }
  
  expect_true(all(bus_delay_data$min_delay <= max_reasonable_delay))
})

