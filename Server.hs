{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ExtendedDefaultRules  #-}

import Yesod
import Yesod.Static 
import System.IO
import Control.Monad
import Control.Monad.IO.Class
import Data.Text hiding (drop) 

data App = App { getStatic :: Static }
instance Yesod App 

staticFiles "public"

mkYesod "App" [parseRoutes|
/ HomeR GET 
/public StaticR Static getStatic
/csv/page/#Int CSVR GET 
|]

getHomeR :: Handler Html
getHomeR = getCSVR 0 

-- Retrieve the CSV headers for the given CSV File
readHeader :: String -> IO String
readHeader f = withFile f ReadMode hGetLine 

-- Skip n * 10 lines and read 10 lines from file f
-- (discounting header) 
readLines :: Int -> String -> IO [String]
readLines n f =
  let pageSize = 10 
  in withFile f ReadMode (replicateM (n * pageSize + pageSize + 1) . hGetLine) >>= return . drop (n * pageSize + 1) 


getCSVR :: Int -> Handler Html
getCSVR pageNumber = do
  let fileName = "public/input.csv" 
  let _pageNumber = max pageNumber 0
  header <- liftIO $ readHeader fileName 
  lines  <- liftIO $ readLines _pageNumber fileName 
  defaultLayout [whamlet|
<div>
  <table>
    <thead>
      $forall headerCell <- splitOn (pack ",") (pack header)
        <th>#{headerCell}
    <tbody> 
      $forall line <- lines
        <tr>
        $forall cell <- splitOn (pack ",") (pack line)
          <td>#{cell} 
<a href=@{CSVR $ max 0 $ pageNumber - 1}>Previous Page
| 
<a href=@{CSVR $ pageNumber + 1}>Next Page 
|]


main :: IO () 
main = do
  static@(Static settings) <- static "public"
  warp 3000 $ App static 


