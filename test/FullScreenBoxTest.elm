import FullScreenBox as FSB
import Graphics.Element (..)
import Color
import Graphics.Input as Input
import Signal
import Window

-- Test stuff
sampleElement : Element
sampleElement =
  spacer 400 200 |> color Color.red

showButton : Element
showButton =
  Input.button (FSB.show sampleElement) "Show"

main : Signal Element
main =
  let
    doubleView screeny = flow outward [showButton, screeny]
    screen = FSB.viewSignal
  in
    Signal.map doubleView screen
