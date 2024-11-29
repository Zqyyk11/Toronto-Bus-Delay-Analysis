#### Preamble ####
# Purpose: Fits a Bayesian regression model to the cleaned bus delay dataset 
#          to identify factors influencing delays, and saves the fitted model.
# Author: Charlie Zhang
# Date: 28th November 2024
# Contact: zqycharlie.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `rstanarm`, `tidyverse`, and `posterior` packages must be installed.
# Any other information needed? Ensure the cleaned data is located in the 
#          `data/02-analysis_data` folder and that the fitted model is saved to the `model` folder.



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
  min_delay ~ incident + day + min_gap,
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
