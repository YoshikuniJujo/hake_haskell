module Tribial (
  takeBaseName
, getDstSrc
) where

import System.Environment (getArgs)

takeBaseName :: String -> String
takeBaseName = takeWhile (/='.')

getDstSrc :: IO (Maybe String, [String])
getDstSrc = do
    args <- getArgs
    let srcs = dropDst args
        dst  = takeDst args
    return (dst, srcs)
  where
  takeDst :: [String] -> Maybe String
  takeDst []            = Nothing
  takeDst ("-o":dst:_)  = Just dst
  takeDst (_:rest)      = takeDst rest
  dropDst :: [String] -> [String]
  dropDst []            = []
  dropDst ("-o":_:rest) = rest
  dropDst (arg:rest)    = arg : dropDst rest
