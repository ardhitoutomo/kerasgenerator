# test settings
#--------------------

# import libs
library(keras)
library(kerasgenerator)
library(recipes)
  
#
#--------------------

set.seed(1)
intrain <- sample(nrow(iris), nrow(iris) * 0.8)

rec <- recipe( ~ ., iris[intrain, ]) %>%
  step_sqrt(all_numeric()) %>%
  step_center(all_numeric()) %>%
  step_scale(all_numeric()) %>%
  step_dummy(all_nominal(), one_hot = TRUE) %>%
  prep()
  
generator <- xsection_generator(iris, batch_size = 32, shuffle = TRUE) %>%
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
