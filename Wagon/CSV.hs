
{-
  CSV
  Module containing CSV Parsing functions. 
-}
module Wagon.CSV (
  readCsv,
  csvLine,
  csvHeader,
  csvFile 
) where

import Text.ParserCombinators.Parsec 
import Wagon.Data 


comma :: Parser () 
comma = char ',' >> return () 


eol :: Parser ()
eol = many (oneOf "\r\n") >> return () 


csvSeparator :: Parser () 
csvSeparator = comma <|> eof <|> eol 


csvVal :: Parser WagonCSVVal
csvVal = many alphaNum >>= return . extractCSVField


csvLine :: Parser [WagonCSVVal]
csvLine = (sepBy1 csvVal comma) <* (eof <|> eol)


csvHeaderCell :: Parser WagonCSVHeader
csvHeaderCell = do
  char '"' 
  title <- many1 letter 
  many space 
  char '(' 
  headerType <- many1 letter 
  char ')' 
  char '"'
  return $ extractCSVHeader headerType title 


csvHeader :: Parser [WagonCSVHeader]
csvHeader = (sepBy1 csvHeaderCell comma) <* (eof <|> eol)


csvFile :: Parser CSVFile 
csvFile = do
  header <- csvHeader
  lines <- many csvLine
  eof
  return $ CSVFile header lines 


readCsv :: Parser [a] -> String -> [a] 
readCsv parser s = case parse parser "csv" s of 
  Right val -> val
  Left err -> error $ show err 


