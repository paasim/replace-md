{-# LANGUAGE OverloadedStrings #-}
module Replace
    ( replaceSection
    ) where

import Data.List.NonEmpty ( NonEmpty (..) )
import Data.Text ( Text )
import System.IO ( isEOF )
import qualified Data.List.NonEmpty as NE
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

-- utils
ifM :: Bool -> IO () -> IO () -> IO ()
ifM b actionTrue actionFalse = if b then actionTrue else actionFalse

ifEOF :: IO () -> IO () -> IO ()
ifEOF actionTrue actionFalse = isEOF >>= \b -> ifM b actionTrue actionFalse

ifPrefix :: Text -> (Text -> IO ()) -> (Text -> IO ()) -> IO ()
ifPrefix prefix actionTrue actionFalse = do
  ln <- TIO.getLine
  ifM (T.isPrefixOf prefix ln) (actionTrue ln) (actionFalse ln)

putSection' :: [Text] -> IO ()
putSection' []     = return ()
putSection' (t:ts) = TIO.putStrLn t >> putSection' ts

putSection :: NonEmpty Text -> IO ()
putSection = putSection' . NE.toList

-- checking lines
-- before the section
checkBefore :: NonEmpty Text -> IO ()
checkBefore ts = ifPrefix (NE.head ts)
  (\_  -> readAt ((`T.snoc` ' ') . fst . T.breakOn " " . NE.head $ ts) ts)
  (\ln -> TIO.putStrLn ln >> readBefore ts)

-- at the section to be replaced
checkAt :: Text -> NonEmpty Text -> IO ()
checkAt prefix ts = ifPrefix prefix
  (\ln -> putSection ts >> TIO.putStrLn ln >> readAfter)
  (\_  -> readAt prefix ts)

-- reading the file
-- before the section
readBefore :: NonEmpty Text -> IO ()
readBefore ts = ifEOF (putSection ts)
                      (checkBefore ts)

-- at the section
readAt :: Text -> NonEmpty Text -> IO ()
readAt prefix ts = ifEOF (putSection ts)
                         (checkAt prefix ts)

-- after the section
readAfter :: IO ()
readAfter = do
  eof <- isEOF
  if eof
    then return ()
    else do
      ln <- TIO.getLine
      TIO.putStrLn ln
      readAfter

--ifEOF (return ())
--                  (TIO.getLine >>= TIO.putStrLn >> readAfter)
                  


-- renamed for exporting
replaceSection :: NonEmpty Text -> IO ()
replaceSection newContent = readBefore newContent

