module ReviewDiff (Diff, readReview, writeReview) where

import Graphics.Element (..)
import Dicc.Model
import String

type alias User = String

basePath : String
basePath = "//dmk3/CodeReviews/"

authorPath : User -> String
authorPath author = basePath ++ author ++ "/"

diccPath : User -> String -> String
diccPath author dicc = (authorPath author) ++ dicc ++ "/"

original : User -> String -> String
original author dicc = (diccPath author dicc) ++ "original"

ref : User -> String -> String
ref author dicc = (diccPath author dicc) ++ "ref"

review : User -> String -> User -> String
review author dicc reviewer =
  (diccPath author dicc) ++ "reviews/" ++ reviewer

type alias Diff = (String, String)

readReview : Dicc.Model.Model -> User -> Diff
readReview diccModel reviewer =
  let
    author = diccModel.author
    dicc = "dicc" ++ diccModel.number
  in
    (review author dicc reviewer, original author dicc)

writeReview : Dicc.Model.Model -> User -> Diff
writeReview diccModel reviewer =
  let
    author = diccModel.author
    dicc = "dicc" ++ diccModel.number
  in
    (ref author dicc, review author dicc reviewer)
