module Dicc.ReviewButton (viewReadButton, main) where

import Dicc.Model
import Graphics.Element (..)
import Graphics.Input as Input
import Color
import CompareUsers
import Text
import FullScreenBox
import ReviewDiff

-- for tests only
import Window
import Signal
--

diffBox (old,new) created =
  flow down [
      if created then
        Text.plainText "Review successfully created!"
      else
        empty,
      Text.plainText "Please diff these two folders",
      Text.asText old,
      Text.asText new
  ]
  |> color Color.white


viewReadButton dicc reviewer =
  let
    text = "Read " ++ reviewer ++"'s review"
    diffs = ReviewDiff.readReview dicc reviewer
    box = diffBox diffs False
  in
    Input.button (FullScreenBox.show box) text


-- Testing

exampleDicc =
  Dicc.Model.init "112345" "pmc" "Kill a walrus"
  |> Dicc.Model.addReview "mlc"
  |> Dicc.Model.addReview "swm"

view diccButton fullscreenBox =
  layers [fullscreenBox, diccButton]


main =
  Signal.map (view (viewReadButton exampleDicc "SWM")) FullScreenBox.viewSignal
