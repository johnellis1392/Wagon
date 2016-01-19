{-# LANGUAGE ExistentialQuantification #-} 

module Main where

import Text.ParserCombinators.Parsec
import Text.Parsec.Error 
import Control.Monad
import Control.Monad.IO.Class 
import System.IO

import Wagon


-- Loop until end of input;
-- Read line of input, split by commas,
-- cast values into their respective types,
-- and then catalogue.
-- We want the count of the columns, and if
-- the column is an integer type, add it to
-- the running average of each type.


-- Read a line of input and return the result 
readInput :: IO [WagonCSVVal]
readInput = do 
  a <- getLine >>= return . (readCsv csvLine) 
  --putStrLn $ show $ a 
  return a 


loop_ :: forall a . Show a => (a -> IO a) -> a -> IO () 
loop_ action state = do
  _end <- isEOF 
  if _end 
    then (putStrLn $ "\nFinal State:\n" ++ show state) >> return () 
    else do result <- action $ state
            --putStrLn $ show $ result
            loop_ action result 


main :: IO ()
main = do
  line <- getLine 
  header <- return $ (createCsvStats $ readCsv csvHeader line) 
  putStrLn $ show $ header 
  loop_ (\h -> readInput >>= return . update h) header



