module Main where

import ReadWrite
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  pn <- getProgName
  handleArgs args pn
