# test settings
#--------------------

# test context
context("test cross-section data generator")

# import libs
library(keras)
library(kerasgenerator)
library(recipes)

#
#--------------------

# test select
keras_generator(iris, batch_size = 32, shuffle = TRUE) %>%
  select_x(-starts_with("Species")) %>%
  select_y(starts_with("Species"))

# test slice
set.seed(1)
intrain <- sample(nrow(iris), nrow(iris) * 0.8)

keras_generator(iris, batch_size = 32, shuffle = TRUE) %>%
  select_x(-starts_with("Species")) %>%
  select_y(starts_with("Species")) %>%
  slice(intrain)

# test recipes
rec <- recipe(Species ~ ., data = iris[intrain, ]) %>%
  step_sqrt(all_numeric()) %>%
  step_center(all_numeric()) %>%
  step_scale(all_numeric()) %>%
  step_dummy(all_nominal(), one_hot = TRUE) %>%
  prep()

keras_generator(iris, batch_size = 32, shuffle = TRUE) %>%
  add_recipe(rec = rec) %>%
  select_x(-starts_with("Species")) %>%
  select_y(starts_with("Species")) %>%
  slice(intrain)

# test build
generator <- keras_generator(iris, batch_size = 32, shuffle = TRUE) %>%
  add_recipe(rec = rec) %>%
  select_x(-starts_with("Species")) %>%
  select_y(starts_with("Species")) %>%
  slice(intrain) %>%
  build_generator()

#
#--------------------

model <- keras_model_sequential() %>%
  layer_dense(16, input_shape = c(4)) %>%
  layer_dense(8) %>%
  layer_dense(3, activation = "softmax")

model %>% compile(
  optimizer = "adam",
  metrics = "accuracy",
  loss = "categorical_crossentropy"
)

history <- model %>% fit_generator(
  generator = generator,
  steps_per_epoch = 6,
  epochs = 10
)

plot(history)
