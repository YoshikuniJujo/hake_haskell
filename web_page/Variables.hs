module Variables (
  htmlXmlns
, catHakefile
, catFile
) where

import Text.RegexPR (gsubRegexPR)

htmlXmlns :: String
htmlXmlns = "http://www.w3.org/1999/xhtml"

catHakefile :: String -> IO String
catHakefile dir = do
  cont_ <- readFile $ "../samples/" ++ dir ++ "/Hakefile"
  let cont = flip (foldr (uncurry gsubRegexPR)) [ (">", "&gt;"), ("<", "&lt;") ] cont_
  return $ "<p>&gt; cat <a href=\"../Hakefile_samples/Hakefile_" ++ dir ++ "\">Hakefile</a></p>\n" ++
           "<pre><code>" ++ cont ++ "</code></pre>"

catFile :: String -> String -> IO String
catFile fn dir = do
  cont_ <- readFile $ "../samples/" ++ dir ++ "/" ++ fn
  let cont = flip (foldr (uncurry gsubRegexPR)) [ (">", "&gt;"), ("<", "&lt;") ] cont_
  return $ "<p>&gt; cat <a href=\"../Hakefile_samples/" ++ fn ++ "_" ++ dir ++ "\">" ++
           fn ++ "</a></p>\n" ++ "<pre><code>" ++ cont ++ "</code></pre>"
