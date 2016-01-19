
--module Main where 

import qualified Wagon as W
import Text.ParserCombinators.Parsec 

import System.Environment 

readCsvFile :: String -> W.CSVFile 
readCsvFile s = case parse W.csvFile "csv" s of
  Left  err -> error $ show err 
  Right val -> val 

main :: IO ()
main = getArgs >>= readFile . head >>= return . readCsvFile >>= putStrLn . show 


