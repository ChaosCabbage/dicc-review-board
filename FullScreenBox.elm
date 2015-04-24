module FullScreenBox (viewSignal, show) where

import Graphics.Element (..)
import Graphics.Input as Input
import List (..)
import Signal
import Color
import Window

type State = Showing Element | NotShowing

showChannel : Signal.Channel State
showChannel =
  Signal.channel NotShowing

state : Signal State
state =
  Signal.subscribe showChannel

show : Element -> Signal.Message
show element =
  Signal.send showChannel (Showing element)

hide : Signal.Message
hide =
  Signal.send showChannel NotShowing

okButton : Element
okButton =
  Input.button hide "OK"

viewShowing : (Int,Int) -> Element -> Element
viewShowing (w,h) el =
  let
    greyish = Color.rgba 100 100 100 0.5
    fullScreen = (container w h middle) >> (color greyish)
    button = okButton |> width (widthOf el)
  in
    fullScreen (flow down [el, button])

viewState : (Int,Int) -> State -> Element
viewState windowDimensions state =
  case state of
    NotShowing -> empty
    Showing e -> viewShowing windowDimensions e

view : (Int,Int) -> State -> Element
view windowDimensions state =
  viewState windowDimensions state

viewSignal : Signal Element
viewSignal = Signal.map2 view Window.dimensions state
