# Load required libraries
install.packages("dplyr")
install.packages("lubridate")
install.packages("ggthemes")
library(dplyr)
library(lubridate)
library(prophet)

# Read the data from CSV files (assuming you have three CSV files with the given format)
april_data <- read.csv("C:\\Users\\sejal\\OneDrive\\Desktop\\Uber\\uber-raw-data-apr14.csv")
may_data <- read.csv("C:\\Users\\sejal\\OneDrive\\Desktop\\Uber\\uber-raw-data-may14.csv")
june_data <- read.csv("C:\\Users\\sejal\\OneDrive\\Desktop\\Uber\\uber-raw-data-jun14.csv")

# Combine data from all three months into one data frame
all_data <- bind_rows(april_data, may_data, june_data)

# Convert "Date" to datetime format and remove rows with missing values
all_data <- all_data %>%
  mutate(ds = as.POSIXct(Date, format = "%m/%d/%Y %H:%M")) %>%
  filter(!is.na(ds))

# Group by date and count pickups
pickup_counts <- all_data %>%
  group_by(ds) %>%
  summarise(y = n())

# Create a Prophet model
model <- prophet()

# Fit the model
model <- fit.prophet(model, pickup_counts)

# Create a data frame for the next month's prediction
next_month_start <- max(pickup_counts$ds) + 1
next_month_end <- next_month_start + 29  # Assuming 30 days in the next month, so 30 - 1
future_dates <- data.frame(ds = seq(from = next_month_start, to = next_month_end, by = "1 day"))

# Predict the next month's pickups
forecast <- predict(model, future_dates)

# Display the results
cat("Predicted pickups for the next month:\n")
print(forecast[c("ds", "yhat")])


install.packages("writexl")
library(writexl)
write_xlsx(forecast, "C:\\Users\\sejal\\OneDrive\\Desktop\\Uber\\july.csv")
