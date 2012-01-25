#!/usr/bin/env runhaskell

> module Main where

> import Tribial

> main :: IO ()
> main = do
>   (Just dst, srcs) <- getDstSrc
>   writeFile (takeBaseName dst ++ ".log") $ dst ++ " is made of " ++ unwords srcs ++ "\n"
>   mapM readFile srcs >>= writeFile dst . concat
