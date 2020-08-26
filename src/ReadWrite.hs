{-# LANGUAGE OverloadedStrings #-}
module ReadWrite
    ( handleArgs
    ) where

import Data.List.NonEmpty ( NonEmpty (..) )
import Data.Text ( Text )
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Replace 

readSection :: FilePath -> IO [Text]
readSection = fmap T.lines . TIO.readFile

validateHeader :: Text -> Either String Text
validateHeader t = let (hashes, header) = T.break (' ' == ) t in
  case (T.all (== '#') hashes, T.length header > 1) of
    (False,_) -> Left "section does not start with hashes (a valid header)"
    (_,False) -> Left "the header of the section is empty"
    (_,_)     -> Right t

validateSection :: [Text] -> Either String (NonEmpty Text)
validateSection []     = Left "section is empty"
validateSection (t:ts) = validateHeader t >> Right (t :| ts)

readAndReplaceSection :: FilePath -> IO ()
readAndReplaceSection fn = do
  section' <- readSection fn
  case validateSection section' of
    (Left err) -> putStrLn err
    (Right ts) -> replaceSection ts

handleArgs :: [String] -> String -> IO ()
handleArgs [fn] _  = readAndReplaceSection fn
handleArgs _    pn = putStrLn $ "usage: " <> pn <> " contents.md"

