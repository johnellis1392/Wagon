

module Wagon.Util (
  isNull, 
  isInt,
  toInt,
) where 


isNull :: String -> Bool
isNull "" = True
isNull _  = False 

isInt :: String -> Bool
isInt s = case (reads s :: [(Int, String)]) of
  [(i, "")] -> True
  _ -> False 

toInt :: String -> Int
toInt "" = 0 
toInt s = case (reads s :: [(Int, String)]) of
  [(i, "")] -> i
  _ -> error "Invalid conversion to integer " 


