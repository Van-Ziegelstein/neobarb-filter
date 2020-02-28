module Neobarb.Forge (
    pipeline
) where


import qualified Data.List as L
import qualified Control.Monad.State as S
import qualified Text.Pandoc.Definition as P
import Text.Pandoc.Walk (walk, walkM)
import Neobarb.Quoting (germanizeQuotes)


-- LaTeX center blocks lose their formatting upon translation to the AST,
-- hence we must manually add back desired styling for each affected snippet.
fixPara :: P.Block -> P.Block
fixPara p@(P.Para xs) = case xs of 
                                y@(P.Str "M." : P.Space : P.Str "Truthblitz" :_) -> plainDiv ["placard","center"] y              
                                y@(P.Strong (P.Str "Nur" : P.Space : P.Str "f\252r" :_) :_) -> plainDiv ["placard"] y
                                [P.Emph y@(P.Str "Mein" : P.Space : P.Str "Mitbewohner" :_)] -> centerQuote y
                                [P.Emph y@(P.Str "Mittagspause" : P.Space : P.Str "-" :_)] -> centerQuote y
                                [P.Emph y@(_:_:P.Str "Overdrive!":_)] -> centerQuote y
                                [P.Emph y@(P.Strong [P.Str "Entropie:"] :_)] -> quoteDiv y
                                [P.Emph y@(P.Str "Und" : P.Space : P.Str "also" :_)] -> quoteDiv y
                                [P.Emph y@(P.Str "F\252r" : P.Space : P.Str "immer" :_)] -> quoteSign y
                                y@(P.Str "K." : P.Space :_) -> quoteSign y
                                _ -> p
                                where
                                    plainDiv c t = P.Div ("", c, []) [ P.Plain t ]
                                    centerQuote = plainDiv ["quote", "center"]
                                    quoteDiv = plainDiv ["quote"]
                                    quoteSign = plainDiv ["placard", "quote"]
fixPara b = b


-- Brute-force recursion to the poem block, as we need a broader view of the AST than the walk functions provide.
-- Then use the monadic walk and state monad to reformat the poem.
fixPoemBlock :: [P.Block] -> [P.Block]
fixPoemBlock [] = []
fixPoemBlock (h@(P.Header _ _ (P.Str "J\228ger":_)) : xs) = let 
                                                            (poem, r) = L.splitAt 16 xs
                                                            injectSpaces (P.Para ps) = do
                                                                lineNum <- S.get
                                                                S.put (lineNum + 1)
                                                                if (lineNum == 5 || lineNum == 11 || lineNum == 16)
                                                                then return $ P.Plain (ps ++ [P.LineBreak, P.LineBreak])
                                                                else return $ P.Plain (ps ++ [P.LineBreak])
                                                        in 
                                                            h : P.Div ("",["quote"],[]) (S.evalState (walkM injectSpaces poem) 0) : r
fixPoemBlock (x:xs) = x : fixPoemBlock xs


-- Lift everything to document level
pipeline :: P.Pandoc -> P.Pandoc
pipeline = (walk fixPoemBlock) . (walk fixPara) . (walk germanizeQuotes)
