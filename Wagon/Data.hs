
{-
  Data
  Module containing data types for parsing CSV's 
-}
module Wagon.Data (
  WagonCSVVal(..), 
  WagonCSVHeader(..),
  CSVFile(..), 
  extractCSVField,
  extractCSVHeader,
  createCsvStats, 
  update 
) where

import Wagon.Util 

-- Value representing a CSV Val 
--data WagonCSVVal = IntVal Integer 
--                 | StringVal String
--                 | InvalidCSVField 
--                 deriving (Show, Eq)
data WagonCSVVal = WagonCSVVal String deriving (Show, Eq) 


-- CSV Header fields Representing a column name and a type 
data WagonCSVHeader = TextHeader String
                    | NumberHeader String
                    | FloatHeader String 
                    | InvalidHeader 
                    deriving (Show, Eq) 


data CSVStats = CSVTextStats {count :: Int,
                              nullCount :: Int,
                              totalLength :: Int, 
                              shortest :: Int,
                              longest :: Int,
                              averageLength :: Double}
              | CSVIntStats {count :: Int,
                             nullCount :: Int, 
                             total :: Int,
                             minVal :: Int,
                             maxVal :: Int,
                             average :: Double} 
              deriving (Eq)

instance Show CSVStats where
  show CSVTextStats {count = c,
                     nullCount = nc,
                     totalLength = tl,
                     shortest = s,
                     longest = l,
                     averageLength = al} =
    "CSVTextStats {\n" ++
    "\tcount = " ++ show c ++ ",\n" ++ 
    "\tnullCount = " ++ show nc ++ ",\n" ++ 
    "\ttotalLength = " ++ show tl ++ ",\n" ++ 
    "\tshortest = " ++ show s ++ ",\n" ++ 
    "\tlongest = " ++ show l ++ ",\n" ++ 
    "\taverageLength = " ++ show al ++ "\n" ++ 
    "}"
  show CSVIntStats {count = c,
                    nullCount = nc, 
                    total = t,
                    minVal = m1,
                    maxVal = m2,
                    average = a} =
    "CSVIntStats {" ++
    "\tcount = " ++ show c ++ "\n," ++
    "\tnullCount = " ++ show nc ++ ",\n" ++ 
    "\ttotal = " ++ show t ++ ",\n" ++
    "\tminVal = " ++ show m1 ++ ",\n" ++ 
    "\tmaxVal = " ++ show m2 ++ ",\n" ++ 
    "\taverageLength = " ++ show a ++ "\n" ++ 
    "}" 


data CSVFile = CSVFile [WagonCSVHeader] [[WagonCSVVal]]
             deriving (Show, Eq) 




extractCSVField :: String -> WagonCSVVal
extractCSVField s = WagonCSVVal s 


extractCSVHeader :: String -> String -> WagonCSVHeader
extractCSVHeader "text" title = TextHeader title 
extractCSVHeader "number" title = NumberHeader title 
extractCSVHeader _ _ = InvalidHeader 


update :: [CSVStats] -> [WagonCSVVal] -> [CSVStats]
update stats vals = fmap update' (zip stats vals)
  where
    update' :: (CSVStats, WagonCSVVal) -> CSVStats
    update' (CSVTextStats {count = c,
                           nullCount = nc,
                           totalLength = tl,
                           shortest = s,
                           longest = l,
                           averageLength = al}, WagonCSVVal w) =
      let c' = c + 1
          nc' = if isNull w then nc + 1 else nc
          tl' = tl + (length w) 
          s' = min (length w) s 
          l' = max (length w) l 
          al' = fromIntegral tl' / fromIntegral c'
      in CSVTextStats
         {count = c',
          nullCount = nc',
          totalLength = tl',
          shortest = s',
          longest = l',
          averageLength = al'} 
         
    update' (CSVIntStats {count = c,
                          nullCount = nc,
                          total = t,
                          minVal = m1,
                          maxVal = m2,
                          average = a}, WagonCSVVal w) =
      if isInt w || isNull w 
      then let w' = toInt w 
               c' = c + 1
               nc' = nc + 1
               t' = t + toInt w
               a' = fromIntegral t' / fromIntegral c'
               min' = min w' m1
               max' = max w' m2
        in CSVIntStats
           {count = c',
            nullCount = nc',
            total = t',
            minVal = min',
            maxVal = max',
            average = a'} 
      else error $ "Invalid command: Not an Integer -- " ++ show w 

    update' _ = error "Invalid type mismatch" 


createCsvStats :: [WagonCSVHeader] -> [CSVStats]
createCsvStats w = fmap createCsvStat w


createCsvStat :: WagonCSVHeader -> CSVStats
createCsvStat (NumberHeader _) =
  CSVIntStats {count = 0,
               nullCount = 0,
               total = 0,
               minVal = (maxBound :: Int),
               maxVal = 0,
               average = 0} 
createCsvStat (TextHeader _) =
  CSVTextStats {count = 0,
               nullCount = 0,
               totalLength = 0,
               shortest = 0,
               longest = 0,
               averageLength = 0} 
createCsvStat _ = error "Invalid type for CSV Statistics" 

