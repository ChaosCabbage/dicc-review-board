module ElementUtils (flowMidline) where

import Graphics.Element (..)
import List (..)


flowMidline : List Element -> Element
flowMidline elements =
  let
    height = maxHeight elements
    contain elm = container (widthOf elm) height middle elm
    containers = map contain elements
  in
    flow right containers


maxHeight : List Element -> Int
maxHeight elements =
  if (isEmpty elements) then 0
  else maximum (map heightOf elements)
