module Main where

import Text.Pandoc.JSON (toJSONFilter)
import Neobarb.ArgForge (optForge)


main :: IO ()
main = toJSONFilter optForge
