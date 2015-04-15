module Styles.Text (style, format) where

import Graphics.Element (..)
import Text



format: Float -> String -> Element
format h s = Text.fromString s
              |> Text.style (style h)
              |> Text.centered

style : Float -> Text.Style
style h =
  let default = Text.defaultStyle
  in
    { default | typeface <- ["Century Gothic", "arial", "sans-serif"],
                      height <- Just h}
