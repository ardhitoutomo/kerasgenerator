# import libs
library(keras)
library(kerasgenerator)
library(lubridate)
library(magrittr)
library(rdatamarket)
library(recipes)
library(tidyverse)

# import dataset
traffic_tbl <- dmlist("http://bit.ly/1W1mCQ3")

# readjust datetime
traffic_tbl %<>%
  select(DateTime, Value) %>%
  mutate(DateTime = ymd_hms(DateTime))

# quick check
glimpse(traffic_tbl)

# set some parameters
lookback <- 12
timesteps <- 12
batch_size <- 12 * 24

# number of train-val-test sample
train_size <- 12 * 24 * 7 * 4
val_size <- 12 * 24 * 7
test_size <- 12 * 24 * 7

# select row indices
test_end <- nrow(traffic_tbl)
test_start <- test_end - test_size + 1

val_end <- test_start - 1
val_start <- val_end - val_size + 1

train_end <- val_start - 1
train_start <- train_end - train_size + 1

# train-val-test indices
intrain <- c(train_end:train_start)
inval <- c(val_end:val_start)
intest <- c(test_end:test_start)

# recipe: square root, center, scale
rec <- recipe(Value ~ Value, traffic_tbl[intrain, ]) %>%
  step_sqrt(all_outcomes()) %>%
  step_center(all_outcomes()) %>%
  step_scale(all_outcomes()) %>%
  prep()

# initiate a generator
gen <- set_series_generator(
  data = traffic_tbl,
  lookback = lookback,
  timesteps = timesteps,
  batch_size = batch_size
)

gen

# inject recipe and select x y
gen %<>%
  inject_recipe(rec = rec) %>%
  select_x(Value) %>%
  select_y(Value)

# split sample
train_gen <- gen %>%
  slice(intrain) %>%
  build_generator()

val_gen <- gen %>%
  slice(inval) %>%
  build_generator()

test_gen <- gen %>%
  slice(intest) %>%
  build_generator()

# initiate a sequential model
model <- keras_model_sequential()

# define the model
model %>%

  # layer lstm
  layer_lstm(
    name = "lstm1",
    input_shape = get_meta(train_gen, "input_shape"),
    units = 128,
    dropout = 0.1,
    recurrent_dropout = 0.2,
    return_sequences = TRUE
  ) %>%

  layer_lstm(
    name = "lstm2",
    units = 64,
    dropout = 0.1,
    recurrent_dropout = 0.2,
    return_sequences = TRUE
  ) %>%

  layer_lstm(
    name = "lstm3",
    units = 32,
    dropout = 0.1,
    recurrent_dropout = 0.2,
    return_sequences = FALSE
  ) %>%

  # layer output
  layer_dense(
    name = "output",
    units = get_meta(train_gen, "output_shape")
  )

# compile the model
model %>% compile(
  optimizer = "rmsprop",
  loss = "mse"
)

# model summary
summary(model)

# fit the model
history <- model %>% fit_generator(
  generator = train_gen,
  validation_data = val_gen,
  epochs = 30
)

plot(history)

# model evaluation
evaluate_generator(model, val_gen)
evaluate_generator(model, test_gen)

#
predict_generator(model, test_gen)

#
forecast_generator(model, test_gen, horizon = lookback)
