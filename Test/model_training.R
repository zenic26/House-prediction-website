# Load libraries
library(readr)
library(dplyr)
library(randomForest)

# Load dataset
data <- read_csv("D:/Housing_prediction/Dataset/housing.csv")
cat("✅ Data loaded!\n")

# Rename columns for easier access
colnames(data) <- c(
  "id", "date", "bedrooms", "bathrooms", "living_area", "lot_area", "floors",
  "waterfront", "views", "condition", "grade", "area_excl_bsmt", "bsmt_area",
  "built_year", "renov_year", "postal_code", "lat", "long", "living_area_renov",
  "lot_area_renov", "schools_nearby", "airport_dist", "price"
)

# Drop NAs
data <- data %>% na.omit()
cat("✅ Cleaned missing values!\n")

# Core features (required)
core_features <- c("bedrooms", "bathrooms", "living_area", "lot_area", "floors")

# Optional features (may or may not be given)
optional_features <- c(
  "waterfront", "views", "condition", "grade", "area_excl_bsmt", "bsmt_area",
  "built_year", "renov_year", "postal_code", "lat", "long",
  "living_area_renov", "lot_area_renov", "schools_nearby", "airport_dist"
)

# Combine features
all_features <- c(core_features, optional_features)

# Ensure all columns exist
data <- data %>% select(all_of(c(all_features, "price")))

# Split into training and test sets
set.seed(123)
indexes <- sample(1:nrow(data), 0.8 * nrow(data))
train_data <- data[indexes, ]
test_data <- data[-indexes, ]

# Split inputs and outputs
x_train <- train_data[, all_features]
y_train <- train_data$price
x_test <- test_data[, all_features]
y_test <- test_data$price

# Train model
model <- randomForest(x = x_train, y = y_train, ntree = 100)
cat("✅ Model trained!\n")

# Save model
saveRDS(model, "D:/Housing_prediction/Test/house_model.rds")
cat("✅ Model saved to house_model.rds\n")

# Evaluate
preds <- predict(model, x_test)
mae <- mean(abs(preds - y_test))
rmse <- sqrt(mean((preds - y_test)^2))
r2 <- 1 - sum((preds - y_test)^2) / sum((y_test - mean(y_test))^2)

# Accuracy score (custom: based on closeness of prediction within 20%)
accuracy <- mean(abs(preds - y_test) <= 0.2 * y_test) * 100

cat("\n📊 Evaluation Metrics:\n")
cat("MAE:", round(mae, 2), "\n")
cat("RMSE:", round(rmse, 2), "\n")
cat("R²:", round(r2, 4), "\n")
cat("🎯 Accuracy (±20% range):", round(accuracy, 2), "%\n")
