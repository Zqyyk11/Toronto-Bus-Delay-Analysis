#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
# Install and load required libraries
library(tidyverse)
library(lubridate)
library(janitor)

# Load the dataset
bus_delay_data <- read.csv("data/01-raw_data/bus_delay_raw_data_2023.csv")

# Clean column names
bus_delay_data <- bus_delay_data %>% 
  clean_names()

# Check for missing values and handle them
bus_delay_data <- bus_delay_data %>%
  mutate(
    min_delay = ifelse(is.na(min_delay), median(min_delay, na.rm = TRUE), min_delay),
    location = replace_na(location, "Unknown"),
    incident = replace_na(incident, "Not Specified")
  ) %>%
  drop_na() # Drop rows with missing values if needed

# Convert columns to appropriate types
bus_delay_data <- bus_delay_data %>%
  mutate(
    date = as.Date(date),
    time = hms::as_hms(time),
    day = factor(day, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")),
    route = as.character(route),
    incident = as.factor(incident),
    direction = as.factor(direction)
  )

# Add derived columns (hour and delay category)
bus_delay_data <- bus_delay_data %>%
  mutate(
    delay_category = case_when(
      min_delay <= 5 ~ "Short",
      min_delay <= 15 ~ "Moderate",
      TRUE ~ "Long"
    )
  )

# Filter out invalid or irrelevant data
bus_delay_data <- bus_delay_data %>%
  filter(min_delay > 0, location != "Unknown")

# Remove duplicate records
bus_delay_data <- bus_delay_data %>%
  distinct()

# Save the cleaned dataset
write.csv(bus_delay_data, "data/02-analysis_data/bus_delay_clean_data_2023.csv", row.names = FALSE)

# Validate the cleaned dataset
summary(bus_delay_data)

# Check unique values for categorical variables
bus_delay_data %>%
  summarise(
    unique_routes = n_distinct(route),
    unique_locations = n_distinct(location),
    unique_incidents = n_distinct(incident)
  )

