#!/usr/bin/env runhaskell

> module Main where

> import Tribial

> main :: IO ()
> main = do
>   (mDst, [src]) <- getDstSrc
>   let dst = maybe (takeBaseName src ++ ".mo") id mDst
>   readFile src >>= writeFile dst . (++"\n") . reverse
