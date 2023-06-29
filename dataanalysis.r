# Load the necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(broom)
library("scatterplot3d")
library(fitdistrplus)

df <- read.csv('/Users/hansamemiya/Voltage Summer/player_stats.csv')

height <- df[, 3]
weight <- df[, 4]
ppg <- df[, 5]
netrating <- df[, 6]

data <- data.frame(height, weight, ppg, netrating)

convert_to_inches <- function(height) {
  parts <- strsplit(height, "-")[[1]]
  feet <- as.numeric(parts[1])
  inches <- as.numeric(parts[2])
  total_inches <- (feet * 12) + inches
  return(total_inches)
}

data$height <- sapply(data$height, convert_to_inches)

# ------------- Histograms-------------------------------

ggplot(data, aes(x = height)) +
  geom_histogram(binwidth = 1, fill = "lightblue", color = "black") +
  labs(x = "Height", y = "Frequency") +
  theme_minimal()

ggplot(data, aes(x = weight)) +
  geom_histogram(binwidth = 5, fill = "lightblue", color = "black") +
  labs(x = "Weight", y = "Frequency") +
  theme_minimal()

ggplot(data, aes(sample = height)) +
  geom_qq() +
  geom_qq_line() +
  labs(x = "Theoretical Quantiles Height", y = "Sample Quantiles Height") +
  theme_minimal()

ggplot(data, aes(sample = weight)) +
  geom_qq() +
  geom_qq_line() +
  labs(x = "Theoretical Quantiles Weight", y = "Sample Quantiles Weight") +
  theme_minimal()

# --------- PPG Distribution---------
library(ggplot2)
library(fitdistrplus)

hist_plot <- ggplot(data, aes(x = ppg)) +
  geom_histogram(binwidth = 1, fill = "lightblue", color = "black") +
  labs(x = "PPG", y = "Frequency") +
  theme_minimal()

qq_plot <- ggplot(data, aes(sample = ppg)) +
  stat_qq(distribution = qpareto, dparams = list(shape = 1, scale = 1),
          color = "red", size = 1) +
  stat_qq_line(distribution = qpareto, dparams = list(shape = 1, scale = 1),
               color = "blue", size = 1) +
  labs(x = "Theoretical Quantiles", y = "Sample Quantiles") +
  theme_minimal()

combined_plot <- gridExtra::grid.arrange(hist_plot, qq_plot, ncol = 2)

print(combined_plot)

#--------- Find the relationship between height and weight-----
ggplot(data, aes(x = height, y = weight)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Height", y = "Weight") +
  theme_minimal()

height-weightcorrelation <- cor(data$height, data$weight)

# --------------------- Height -------------------------------
heightmodel <- lm(ppg ~ height, data = data)

heightcoefs <- tidy(heightmodel)

ggplot(data, aes(x = height, y = ppg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Height", y = "PPG") +
  theme_minimal()

# --------------------- Weight -------------------------------
model_weight <- lm(ppg ~ weight, data = data)

coefs_weight <- tidy(model_weight)

ggplot(data, aes(x = weight, y = ppg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Weight", y = "PPG") +
  theme_minimal()

# --------------------- Height + Weight -------------------------------
model_height_weight <- lm(ppg ~ height + weight, data = data)

coefs_height_weight <- tidy(model_height_weight)

model_height_weight <- lm(ppg ~ height + weight, data = data)

scatterplot3d(data$weight, data$height, data$ppg, pch = 16, color = "blue",
              xlab = "Weight", ylab = "Height (inches)", zlab = "PPG")

weight_grid <- seq(min(data$weight), max(data$weight), length.out = 20)
height_grid <- seq(min(data$height), max(data$height), length.out = 20)
grid_data <- expand.grid(weight = weight_grid, height = height_grid)

grid_data$ppg <- predict(model_height_weight, newdata = grid_data)

grid_matrix <- matrix(grid_data$ppg, nrow = length(height_grid), ncol = length(weight_grid), byrow = TRUE)

persp3d(x = weight_grid, y = height_grid, z = grid_matrix, col = "red", alpha = 0.3)

legend("topright", legend = "Regression Plane", fill = "red")

model_height_weight <- lm(ppg ~ height + weight, data = data)

summary(model_height_weight)
