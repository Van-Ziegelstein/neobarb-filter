module Main where

import Text.Pandoc.JSON
import Neobarb.Forge


main :: IO ()
main = toJSONFilter pipeline
