module Dicc.View (view) where

import Dicc.Model as DM
import ElementUtils (flowMidline)

import Graphics.Element (..)
import Graphics.Collage (..)
import List
import Text
import Color
import Styles.Text

textFormat = Styles.Text.format 20

background = Color.white

containLeft w element =
  container w (12 + (heightOf element)) midLeft element

view : DM.Model -> (Int,Int) -> Element
view model (w,h) =

  let reviews = flowMidline [
        verticalSpacer,
        viewReviews model.reviews
      ]

      identifiers = flowMidline [
        viewUsername model.author,
        verticalSpacer,
        viewNumber model.number
      ]

      remainingWidth = w - (widthOf reviews) - (widthOf identifiers) - 20

      description =
        if (remainingWidth < 0) then
          empty
        else
          flowMidline [
            verticalSpacer,
            viewDescription model.description |> containLeft remainingWidth
          ]


  in flowMidline [identifiers, description, reviews]
    |> containLeft w
    |> color background


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
viewUsername user = textFormat user |> width 60

viewNumber : String -> Element
viewNumber n = textFormat n |> width 80

viewDescription : String -> Element
viewDescription desc = textFormat desc

viewReviews : List String -> Element
viewReviews reviews =
  List.map (Text.fromString >> Text.centered >> width 50) reviews
    |> flow down
