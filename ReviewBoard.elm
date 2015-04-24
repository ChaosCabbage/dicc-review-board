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
import CompareUsers
import FullScreenBox

-- PORTS
port username : Signal String

port diccs : Signal (List String)

formatRight = format midRight
formatLeft = format midLeft

format position string textHeight screenWidth =
  let text = Styles.Text.format textHeight string
  in container screenWidth (heightOf text) position text

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
  List.partition (.author >> (CompareUsers.same author))


viewDiccList diccs (w,h) =
  let view dicc = Dicc.View.view dicc (w,h)
  in
    flow down [
      (format midRight "Reviews: " 25 w),
      (flow down (List.map view diccs))
    ]


multiView diccs user (w,h) =
  let view dicc = Dicc.View.view dicc (w,h)
      (yours,theirs) = splitByAuthor user diccs

      listWidth = max 300 ((w*3) // 4)

      viewList name diccs =
        flow down [
          (spacer listWidth 20),
          (format midLeft name 30 listWidth),
          (viewDiccList diccs (listWidth,h))
        ]
  in
    flow down [
      (welcome user w),
      (spacer w 20),
      container w h midTop (flow down [
        (viewList "Your DICCs" yours),
        (viewList "Other DICCs" theirs)
      ])
    ]



-- Wiring

decodedDiccs : Signal (List Dicc.Model.Model)
decodedDiccs = decode <~ diccs

mainView : Signal Element
mainView = multiView <~ decodedDiccs ~ username ~ Window.dimensions

mainViewWithOverlay : Element -> Element -> Element
mainViewWithOverlay page overlay = layers [page, overlay]

main : Signal Element
main = mainViewWithOverlay <~ mainView ~ FullScreenBox.viewSignal
