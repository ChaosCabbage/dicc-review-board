module CompareUsers (formatted, same) where

import String

formatted : String -> String
formatted = String.trim >> String.toLower

same : String -> String -> Bool
same user1 user2 =
  (formatted user1) == (formatted user2)
