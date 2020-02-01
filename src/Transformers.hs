module Transformers (
module Text.Pandoc.JSON,
pipeline
) where


import Data.List
import Control.Monad.State
import Text.Pandoc.JSON
import Text.Pandoc.Walk


-- Guillemets are prefered in German book formatting over standard quotes.
germanizeQuotes :: Inline -> Inline
germanizeQuotes (Quoted _ xs) = Span ("", [], []) $ Str "\187" : xs ++ [ Str "\171" ]
germanizeQuotes i = i


-- LaTex center blocks lose their formatting upon translation to the AST,
-- hence we must manually add back desired styling for each affected snippet.
fixPara :: Block -> Block
fixPara p@(Para xs) = case xs of 
                                y@(Str "M." : Space : Str "Truthblitz" :_) -> plainDiv ["placard","center"] y              
                                y@(Strong (Str "Nur" : Space : Str "f\252r" :_) :_) -> plainDiv ["placard"] y
                                [Emph y@(Str "Mein" : Space : Str "Mitbewohner" :_)] -> centerQuote y
                                [Emph y@(Str "Mittagspause" : Space : Str "-" :_)] -> centerQuote y
                                [Emph y@(_:_:Str "Overdrive!":_)] -> centerQuote y
                                [Emph y@(Strong [Str "Entropie:"] :_)] -> quoteDiv y
                                [Emph y@(Str "Und" : Space : Str "also" :_)] -> quoteDiv y
                                [Emph y@(Str "F\252r" : Space : Str "immer" :_)] -> quoteSign y
                                y@(Str "K." : Space :_) -> quoteSign y
                                _ -> p
                                where
                                    plainDiv c t = Div ("", c, []) [ Plain t ]
                                    centerQuote = plainDiv ["quote", "center"]
                                    quoteDiv = plainDiv ["quote"]
                                    quoteSign = plainDiv ["placard", "quote"]
fixPara b = b


-- Brute-force recursion to the poem block, as we need a broader view of the AST than the walk functions provide.
-- Then use the monadic walk and state monad to reformat the poem.
fixPoemBlock :: [Block] -> [Block]
fixPoemBlock [] = []
fixPoemBlock (h@(Header _ _ (Str "J\228ger":_)) : xs) = let 
                                                            (poem, r) = splitAt 16 xs
                                                            injectSpaces (Para ps) = do
                                                                lineNum <- get
                                                                put (lineNum + 1)
                                                                if (lineNum == 5 || lineNum == 11 || lineNum == 16)
                                                                then return $ Plain (ps ++ [LineBreak, LineBreak])
                                                                else return $ Plain (ps ++ [LineBreak])
                                                        in 
                                                            h : Div ("",["quote"],[]) (evalState (walkM injectSpaces poem) 0) : r
fixPoemBlock (x:xs) = x : fixPoemBlock xs


-- Lift everything to document level
pipeline :: Pandoc -> Pandoc
pipeline = (walk fixPoemBlock) . (walk fixPara) . (walk germanizeQuotes)
