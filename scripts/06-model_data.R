#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace Setup ####
library(tidyverse)
library(caret)
library(randomForest)

# Load the dataset
bus_delay_data <- read.csv("data/02-analysis_data/bus_delay_clean_data_2023.csv")

#### Data Preparation ####
# Handle missing values
bus_delay_data <- bus_delay_data %>%
  mutate(
    min_delay = ifelse(is.na(min_delay), median(min_delay, na.rm = TRUE), min_delay),
    min_gap = ifelse(is.na(min_gap), median(min_gap, na.rm = TRUE), min_gap),
    location = replace_na(location, "Unknown"),
    incident = replace_na(incident, "Not Specified")
  )

# Convert categorical variables to factors
bus_delay_data <- bus_delay_data %>%
  mutate(
    day = as.factor(day),
    incident = as.factor(incident),
    location = as.factor(location)
  )

# Add an hour column if not already present
bus_delay_data <- bus_delay_data %>%
  mutate(
    time = lubridate::hm(time),  # Convert character to time (hours and minutes)
    hour = lubridate::hour(time)  # Extract the hour
  )

# Split the data into training (70%) and testing (30%) sets
set.seed(123)  # For reproducibility
train_index <- createDataPartition(bus_delay_data$min_delay, p = 0.7, list = FALSE)
train_data <- bus_delay_data[train_index, ]
test_data <- bus_delay_data[-train_index, ]

#### Model Building ####
# Linear Regression Model
lm_model <- lm(min_delay ~ incident + day + hour + location + min_gap, data = train_data)
cat("Linear Regression Model Summary:\n")
print(summary(lm_model))

# Random Forest Model
rf_model <- randomForest(
  min_delay ~ incident + day + hour + location + min_gap,
  data = train_data,
  ntree = 100,  # Number of trees
  importance = TRUE  # Variable importance
)
cat("Random Forest Model Summary:\n")
print(rf_model)

# Plot variable importance for the Random Forest model
varImpPlot(rf_model)

#### Model Evaluation ####
# Evaluate Linear Regression
lm_predictions <- predict(lm_model, newdata = test_data)
lm_rmse <- sqrt(mean((test_data$min_delay - lm_predictions)^2))
lm_r2 <- cor(test_data$min_delay, lm_predictions)^2
cat("Linear Regression Performance:\n")
cat("RMSE:", lm_rmse, "\n")
cat("R-squared:", lm_r2, "\n")

# Evaluate Random Forest
rf_predictions <- predict(rf_model, newdata = test_data)
rf_rmse <- sqrt(mean((test_data$min_delay - rf_predictions)^2))
rf_r2 <- cor(test_data$min_delay, rf_predictions)^2
cat("Random Forest Performance:\n")
cat("RMSE:", rf_rmse, "\n")
cat("R-squared:", rf_r2, "\n")

#### Save the Best Model ####
# Compare models and save the best one
if (rf_rmse < lm_rmse) {
  cat("Random Forest performs better. Saving the Random Forest model.\n")
  saveRDS(rf_model, "rf_model.rds")
} else {
  cat("Linear Regression performs better. Saving the Linear Regression model.\n")
  saveRDS(lm_model, "lm_model.rds")
}


