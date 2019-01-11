# prepare environment
#--------------------

# clear environment
rm(list = ls())

# load libs
pacman::p_load(kerasgenerator)

#
#--------------------

#
gen <- data_generator(iris, x = 1, y = 2, shuffle = FALSE)

glimpse(gen)

batch <- gen()

glimpse(batch)
