library(plumber)
library(randomForest)

# Load model
model <- readRDS("D:/Housing_prediction/Test/house_model.rds")

# Core and optional features
core_features <- c("bedrooms", "bathrooms", "living_area", "lot_area", "floors")
optional_features <- c(
  "waterfront", "views", "condition", "grade", "area_excl_bsmt", "bsmt_area",
  "built_year", "renov_year", "postal_code", "lat", "long",
  "living_area_renov", "lot_area_renov", "schools_nearby", "airport_dist"
)
all_features <- c(core_features, optional_features)

default_values <- setNames(as.list(rep(0, length(all_features))), all_features)

# Enable CORS
# This will allow requests from other origins (like http://127.0.0.1:5500)
# when using JavaScript fetch()
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type")
  plumber::forward()
}

#* @apiTitle Housing Price Prediction API

#* Predict house price
#* @get /predict
#* @param bedrooms:int
#* @param bathrooms:double
#* @param living_area:int
#* @param lot_area:int
#* @param floors:int
#* @param waterfront:int
#* @param views:int
#* @param condition:int
#* @param grade:int
#* @param area_excl_bsmt:int
#* @param bsmt_area:int
#* @param built_year:int
#* @param renov_year:int
#* @param postal_code:int
#* @param lat:double
#* @param long:double
#* @param living_area_renov:int
#* @param lot_area_renov:int
#* @param schools_nearby:int
#* @param airport_dist:double
#* @serializer unboxedJSON
function(bedrooms = NA, bathrooms = NA, living_area = NA, lot_area = NA, floors = NA,
         waterfront = NA, views = NA, condition = NA, grade = NA,
         area_excl_bsmt = NA, bsmt_area = NA, built_year = NA, renov_year = NA,
         postal_code = NA, lat = NA, long = NA,
         living_area_renov = NA, lot_area_renov = NA,
         schools_nearby = NA, airport_dist = NA) {
  
  input <- list(
    bedrooms = bedrooms, bathrooms = bathrooms, living_area = living_area,
    lot_area = lot_area, floors = floors, waterfront = waterfront,
    views = views, condition = condition, grade = grade,
    area_excl_bsmt = area_excl_bsmt, bsmt_area = bsmt_area,
    built_year = built_year, renov_year = renov_year,
    postal_code = postal_code, lat = lat, long = long,
    living_area_renov = living_area_renov, lot_area_renov = lot_area_renov,
    schools_nearby = schools_nearby, airport_dist = airport_dist
  )
  
  for (name in names(input)) {
    if (is.na(input[[name]])) {
      input[[name]] <- default_values[[name]]
    } else {
      input[[name]] <- as.numeric(input[[name]])
    }
  }
  
  input_df <- as.data.frame(input)
  input_df <- input_df[, all_features, drop = FALSE]
  
  prediction <- predict(model, input_df)
  range <- round(prediction * c(0.9, 1.1))
  
  list(
    min_price = range[1],
    max_price = range[2],
    predicted_price = round(prediction, 2)
  )
}
