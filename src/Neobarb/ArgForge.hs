module Neobarb.ArgForge (
    optForge
) where


import System.Console.GetOpt
import Data.Char (toLower)
import Text.Pandoc.Definition (Pandoc)
import Neobarb.Smelter (smeltBookParts, smeltLangParts)


data Options = Options { 

    optBook :: String, 
    optLang :: String
}


defaultOptions = Options {

    optBook = "pillagers",
    optLang = "de"
}


options :: [OptDescr (Options -> Options)]
options =
        [ 
            Option ['b'] ["book"] 
            (ReqArg (\b opts -> opts { optBook = map (toLower) b }) "BOOK") 
            "The tribal scripture to be converted.", 

            Option ['l'] ["language"] 
            (ReqArg (\l opts -> opts { optLang = map (toLower) l }) "LANGUAGE") 
            "The language rules to use for the conversion." 
        ]


optForge :: [String] -> Pandoc -> Pandoc
optForge argv = case getOpt Permute options argv of
                        
                        (o, _, []) -> 
                                        let 
                                            uOpts = foldl (flip id) defaultOptions o
                                        in
                                            (smeltBookParts $ optBook uOpts) . (smeltLangParts $ optLang uOpts) 
                                                
                        (_, _, errs) -> id
