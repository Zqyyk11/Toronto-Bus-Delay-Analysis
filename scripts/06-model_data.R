#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(posterior)

#### Read data ####
# Load the cleaned dataset
bus_delay_data <- read_csv("data/02-analysis_data/bus_delay_clean_data_2023.csv")

# Reduce the dataset for faster modeling (optional)
analysis_reduced <- bus_delay_data |> 
  slice_sample(n = 2000)

#### Model data ####
# Define the model using stan_glm
delay_model <- stan_glm(
  min_delay ~ incident + location + min_gap,
  data = analysis_reduced,
  family = gaussian(link = 'identity'),  
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  seed = 987
)

#### Save model ####
saveRDS(
  delay_model,
  file = "models/bus_delay_model.rds"
)
