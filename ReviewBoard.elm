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

decode : List String -> (Int,Int) -> List Element
decode dicclist dimensions =
  let
    results = List.map (Dicc.Parse.parse) dicclist
      |> Debug.watch "decoding"
  in List.map (\b ->
        case b of
          Ok v -> Dicc.View.view v dimensions
          Err e -> Text.asText ("Error!!! " ++ e)
      ) results


multiView diccs undecoded user w =
  flow down [
    (welcome user w),
    (spacer w 20),
    (formatRight "Reviews: " 25 w),
    (flow down (diccs))
  ]


main =
  let
    decodedDiccs = decode <~ diccs ~ Window.dimensions
  in
    multiView <~ decodedDiccs ~ diccs ~ username ~ Window.width
