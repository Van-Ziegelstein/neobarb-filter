module Main where

import Text.Pandoc.JSON (toJSONFilter)
import Neobarb.Forge (pipeline)


main :: IO ()
main = toJSONFilter pipeline
