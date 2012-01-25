#!/usr/bin/env runhaskell

> import System.Environment (getArgs)
> import System.Exit        (exitFailure)
> import Data.List          (isSuffixOf)

> main = do
>  putStrLn "I am pp."
>  [ src ] <- getArgs
>  if isSuffixOf ".pp" src
>     then readFile src >>= writeFile (init (init (init src)))
>     else exitFailure
