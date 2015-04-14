module Test (main) where

import Dicc.View
import Dicc.Model

import List

sample : Dicc.Model.Model
sample =
  Dicc.Model.init 11234 "pmc" "Get rid of all the code"

reviews = ["mlc", "swm"]

main = Dicc.View.view
  (List.foldl Dicc.Model.addReview sample reviews)
