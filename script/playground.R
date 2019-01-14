library(dplyr)
library(keras)
library(kerasgenerator)
library(recipes)

set.seed(1)
intrain <- sample(nrow(iris), nrow(iris) * 0.8)

rec <- recipe( ~ ., iris[intrain, ]) %>%
  step_sqrt(all_numeric()) %>%
  step_center(all_numeric()) %>%
  step_scale(all_numeric()) %>%
  step_dummy(all_nominal(), one_hot = TRUE) %>%
  prep()
  
gen <- data_generator(iris, batch_size = 32, shuffle = TRUE) %>%
  add_recipe(rec = rec) %>%
  select_x(-starts_with("Species")) %>%
  select_y(starts_with("Species"))
  
train_gen <- gen %>%
  slice(intrain) %>%
  build_generator()

val_gen <- gen %>%
  slice(-intrain) %>%
  build_generator()

model <- keras_model_sequential() %>%

  layer_dense(
    name = "dense1",
    units = 16,
    input_shape = get_meta(train_gen, "input_shape")
  ) %>%
  
  layer_dense(
    name = "dense2",
    units = 8
  ) %>%
  
  layer_dense(
    name = "dense_output",
    units = get_meta(train_gen, "output_shape"),
    activation = "softmax"
  )

model %>% compile(
  optimizer = "adam",
  metrics = "accuracy",
  loss = "categorical_crossentropy"
)

history <- model %>% fit_generator(
  generator = train_gen,
  validation_data = val_gen,
  epochs = 30
)

plot(history)

model %>% evaluate_generator(generator = val_gen)

model %>% predict_generator(generator = val_gen)
