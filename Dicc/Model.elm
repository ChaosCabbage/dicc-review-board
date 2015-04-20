module Dicc.Model (Model, User, init, addReview) where

import List

type alias User = String

type alias Model = {
  number: String,
  author: User,
  description: String,
  reviews: List User
}

init : String -> User -> String -> Model
init number author description =
  {
    number = number,
    author = author,
    description = description,
    reviews = []
  }

addReview : User -> Model -> Model
addReview reviewer model =
  { model | reviews <- reviewer :: (model.reviews) }
