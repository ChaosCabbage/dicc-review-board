module Dicc.Parse (parse) where

import Dicc.Model as DM
import Json.Decode (..)
import List


constructDiccWithReviews : DM.Model -> List String -> DM.Model
constructDiccWithReviews dicc reviews =
  List.foldl DM.addReview dicc reviews

diccoder : Decoder DM.Model
diccoder =
  object3 DM.init
    ("number" := string)
    ("author" := string)
    ("description" := string)

metaDiccDecoder : Decoder DM.Model
metaDiccDecoder =
  object2 constructDiccWithReviews
    ("dicc" := diccoder)
    ("reviews" := (list string))

parse : String -> Result String DM.Model
parse json =
  decodeString metaDiccDecoder json
