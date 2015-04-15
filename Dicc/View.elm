module Dicc.View (view) where

import Dicc.Model as DM
import ElementUtils (flowMidline)

import Graphics.Element (..)
import Graphics.Collage (..)
import List
import Text
import Color
import Styles.Text

textFormat = Styles.Text.format 12

view : DM.Model -> Element
view model =
  flowMidline (List.intersperse verticalSpacer [
    viewUsername model.author,
    viewNumber model.number,
    viewDescription model.description,
    viewReviews model.reviews
  ])
  |> (\e -> container 500 (12 + (heightOf e)) midLeft e)
  |> color Color.lightOrange


lineStyle =
  { defaultLine | width <- 1,
                  cap <- Round,
                  color <- Color.red }

verticalSpacer : Element
verticalSpacer =
  collage 12 24 [
    traced lineStyle (segment (0,12) (0,-12))
  ]

doReviewText : Bool -> String
doReviewText alreadyReviewing =
  if alreadyReviewing then
    "Continue your review"
  else
    "Start reviewing this"

viewUsername : DM.User -> Element
viewUsername user = textFormat user

viewNumber : String -> Element
viewNumber n = textFormat n

viewDescription : String -> Element
viewDescription desc =
  let
    text = textFormat desc
    w = min 200 (widthOf text)
  in
    width w text

viewReviews : List String -> Element
viewReviews reviews =
  List.map (Text.fromString >> Text.centered >> width 50) reviews
    |> flow down
