module ReviewBoard (main) where

import Dicc.View
import Dicc.Model
import Dicc.Parse
import Graphics.Element (..)
import Signal (..)
import Text
import Debug
import List
import Time
import Result
import String
import Styles.Text
import Window

-- PORTS
port username : Signal String

port diccs : Signal (List String)

formatRight string textHeight screenWidth =
  let text = Styles.Text.format textHeight string
  in container screenWidth (heightOf text) midRight text

welcome name w =
  formatRight ("Welcome, " ++ name) 50 w

decode : List String -> List Dicc.Model.Model
decode dicclist =
  let
    results = List.map (Dicc.Parse.parse) dicclist
      |> Debug.watch "decoding"

    goodResults = List.filter (\dicc ->
        case dicc of
          Ok _ -> True
          Err _ -> False
      ) results

  in
    List.map (\(Ok x) -> x) goodResults


splitByAuthor author =
  List.partition (\d -> d.author == author)

viewDiccList diccs (w,h) =
  let view dicc = Dicc.View.view dicc (w,h)
  in
    flow down [
      (formatRight "Reviews: " 25 w),
      (flow down (List.map view diccs))
    ]

multiView diccs user (w,h) =
  let view dicc = Dicc.View.view dicc (w,h)
  in
    flow down [
      (welcome user w),
      (spacer w 20),
      (viewDiccList diccs (w,h))
    ]


main =
  let
    decodedDiccs = decode <~ diccs
  in
    multiView <~ decodedDiccs ~ username ~ Window.dimensions
