module EhsTools (
  cgiPage
) where

cgiPage :: IO String -> IO String -> IO String -> IO String
cgiPage title pre body = do
  t <- title
  p <- pre
  b <- body
  return $ "#!/usr/local/bin/perl\n" ++
            plPrint "Content-type: text/html\n\n" ++
            plPrint "<?xmml version=\"1.0\" encoding=\"utf8\" ?>\n" ++
            plPrint ("<html xmlns=\"http://www.w3.org/1999/xhtml\">") ++
            plPrint ("<head><title>" ++ t ++ "</title></head>") ++
            plPrint ("<body><h1>" ++  t ++ "</h1>") ++
	    plPrint p ++
	    b ++ plPrint "</body></html>\n"

plPrint :: String -> String
plPrint str = "print " ++ show str ++ ";\n"
