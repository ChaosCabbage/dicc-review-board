module ReviewBoard (main) where

import Dicc.View
import Dicc.Model
import Graphics.Element (..)
import Signal (..)
import Text
import Json.Decode (..)
import Debug
import List
import Time
import Result
import String
import Styles.Text

-- PORTS
port username : Signal String

port diccs : Signal (List String)


-- testDiccs =
--   let diccsPerSecond = map2 (,)
--         (constant ["{\"number\":119490,\"author\":\"chb\",\"description\":\"Parameters that are needed for automatic tool axis limits\"}"] )
--         (Time.fps 1)
--   in
--     (\(ls, f) -> ls) <~ diccsPerSecond



welcome name = Styles.Text.format 50 ("Welcome, " ++ name)

diccoder : Decoder Dicc.Model.Model
diccoder =
  object3 Dicc.Model.init
    ("number" := string)
    ("author" := string)
    ("description" := string)


decode : List String -> List Element
decode dicclist =
  let
    results = List.map (decodeString diccoder) dicclist
      |> Debug.watch "decoding"
  in List.map (\b ->
        case b of
          Ok v -> Dicc.View.view v
          Err e -> Text.asText ("Error!!! " ++ e)
      ) results


multiView diccs undecoded user =
  flow down [
    (welcome user),
    --(flow down (List.map Text.asText undecoded)),
    (flow down (diccs))
  ]


main =
  let
    decodedDiccs = decode <~ diccs
  in
    multiView <~ decodedDiccs ~ diccs ~ username
