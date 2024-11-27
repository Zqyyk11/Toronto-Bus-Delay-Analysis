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
library(lubridate)
library(ggplot2)

# Load the dataset
bus_delay_data <- read.csv("data/02-analysis_data/bus_delay_clean_data_2023.csv")  

#### Data Overview ####
# Quick overview of the data
glimpse(bus_delay_data)

# Summary statistics for numeric variables
summary(bus_delay_data)

# Check for missing values
missing_values <- colSums(is.na(bus_delay_data))
print("Missing values per column:")
print(missing_values)

# Inspect unique values in categorical columns
print("Unique values in 'day':")
print(unique(bus_delay_data$day))

print("Unique values in 'incident':")
print(unique(bus_delay_data$incident))

#### Analyze Delays ####
# Distribution of delays
ggplot(bus_delay_data, aes(x = min_delay)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Bus Delays", x = "Delay (minutes)", y = "Frequency") +
  theme_minimal()

# Save histogram
ggsave("other/Graphs/delay_distribution.png", width = 8, height = 6)

# Boxplot to identify outliers
ggplot(bus_delay_data, aes(y = min_delay)) +
  geom_boxplot(fill = "orange", color = "black", alpha = 0.7) +
  labs(title = "Boxplot of Bus Delays", y = "Delay (minutes)") +
  theme_minimal()

# Delay summary statistics
delay_summary <- bus_delay_data %>% 
  summarise(
    mean_delay = mean(min_delay, na.rm = TRUE),
    median_delay = median(min_delay, na.rm = TRUE),
    max_delay = max(min_delay, na.rm = TRUE),
    min_delay = min(min_delay, na.rm = TRUE)
  )
print("Summary statistics for delays:")
print(delay_summary)

#### Analyze Incident Types ####
# Frequency of incidents
incident_count <- bus_delay_data %>%
  count(incident) %>%
  arrange(desc(n))
print("Incident count:")
print(incident_count)

# Bar plot of incident types
bus_delay_data %>%
  count(incident) %>%
  ggplot(aes(x = reorder(incident, -n), y = n, fill = incident)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  labs(title = "Frequency of Incident Types", x = "Incident Type", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Boxplot of delays by incident type
ggplot(bus_delay_data, aes(x = incident, y = min_delay, fill = incident)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Bus Delays by Incident Type", x = "Incident Type", y = "Delay (minutes)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#### Temporal Analysis ####
# Average delay by day of the week
bus_delay_data %>%
  group_by(day) %>%
  summarise(avg_delay = mean(min_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(day, avg_delay), y = avg_delay, fill = day)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  labs(title = "Average Delay by Day of the Week", x = "Day", y = "Average Delay (minutes)") +
  theme_minimal()

#### Spatial Analysis ####
# Top 10 locations with most delays
bus_delay_data %>%
  count(location, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(location, n), y = n, fill = location)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  labs(title = "Top 10 Locations with Most Delays", x = "Location", y = "Number of Delays") +
  coord_flip() +
  theme_minimal()

#### Correlation Analysis ####
# Scatter plot of delay vs gap
ggplot(bus_delay_data, aes(x = min_gap, y = min_delay)) +
  geom_point(alpha = 0.5, color = "purple") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Scatter Plot of Delay vs Gap", x = "Gap (minutes)", y = "Delay (minutes)") +
  theme_minimal()

# Correlation between delay and gap
correlation <- cor(bus_delay_data$min_delay, bus_delay_data$min_gap, use = "complete.obs")
print(paste("Correlation between delay and gap:", round(correlation, 2)))

#### Save Outputs ####
# Save delay summary statistics to a CSV
write.csv(delay_summary, "other/analyzed_files/delay_summary.csv", row.names = FALSE)

# Save incident count to a CSV
write.csv(incident_count, "other/analyzed_files/incident_count.csv", row.names = FALSE)

