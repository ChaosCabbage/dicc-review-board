module ReviewBoardEntry (main) where

import Graphics.Element (..)
import Graphics.Input.Field as Field
import Text
import Signal (..)
import Window
import List
import Keyboard
import Styles.Text

-- MODEL

type Update =
  Name Field.Content
  | Submit

-- CHANNELS

updateChannel : Channel Update
updateChannel = channel Submit

-- VIEW

format: Float -> String -> Element
format = Styles.Text.format

welcome = format 50 "Welcome to the DMK Review Board"
who = format 40 "Who are you?"
initials = format 15 "3 letter initials please"

fieldStyle : Field.Style
fieldStyle =
  let default = Field.defaultStyle
  in
    { default | style <- (textFormat 30) }

nameField : Field.Content -> Element
nameField content =
  Field.field Field.defaultStyle (send updateChannel << Name) "Initials" content
  |> height 40
  |> width 60
  |> container 100 50 middle


view : (Int,Int) -> Field.Content -> Element
view (w,h) username =
  flow down (List.map (width w) [
    welcome,
    who,
    nameField username,
    initials
  ])
  |> container w (h//2) middle

update update model =
  case update of
    Submit -> model
    Name content -> content

model : Signal Field.Content
model =
  subscribe updateChannel
    |> foldp update Field.noContent

main =
  view <~ (Window.dimensions) ~ model


port redirect : Signal String
port redirect =
    toUrl <~ model ~ Keyboard.enter


toUrl username go =
  case go of
    True -> "reviewboard.html?user=" ++ username.string
    _ -> ""
