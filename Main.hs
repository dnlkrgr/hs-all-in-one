module Main where

import           HsAllInOne                     ( hsAllInOne )
import           System.Environment             ( getArgs )

main :: IO ()
main = do
    filenames <- getArgs
    hsAllInOne filenames
