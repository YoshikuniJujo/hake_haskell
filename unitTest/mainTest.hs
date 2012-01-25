module Main where

import Test.HUnit
import Development.Hake.Types
import Development.Hake.Core
import Development.Hake

main = runTestTT $ test testData

testData = [
   "traseRule" ~: traceRuleTest
 ]

getTwoOfTraceRuleRet :: [[ RuleRet ]] -> [[ (TargetRet, SourcesRet) ]]
getTwoOfTraceRuleRet = map $ map $ \(a,(b,c)) -> (a,b)

traceRuleTest = [
   Just []   ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just False) "" [])
 , Just [[]] ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just True)  "" [])
 , Just []   ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just False) "hello" [])
 , Just [[]] ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just True)  "hello" [])
 , Just []   ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just False) "hello"
                 [((=="hello"), (const ["hello.o"], \_ _ -> return ()))])
 , Just [[("hello", ["hello.o"])], []]
             ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just True)  "hello"
                 [((=="hello"), (const ["hello.o"], \_ _ -> return ()))])
 , Just [[("hello", ["hello.o"])], []]
             ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just True)  "hello"
                 [(const True, (\t -> [t ++ ".o"], \_ _ -> return ()))])
 , Just [[("hello", ["hello.o"]), ("hello.o", ["hello.o.o"])],
         [("hello", ["hello.o"])],
	 [("hello", ["hello.o"]), ("hello.o", ["hello.o.o"])],
         [("hello", ["hello.o"])], []]
             ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just True)  "hello"
                 [(const True, (\t -> [t ++ ".o"], \_ _ -> return ())),
                  (const True, (\t -> [t ++ ".o"], \_ _ -> return ()))])
 , Just [[("hello", ["hello.o"]), ("hello.o", ["hello.c"])],
         [("hello", ["hello.o"])], []]
             ~=? fmap getTwoOfTraceRuleRet (traceRule id (const $ Just True)  "hello"
                 [(const True, (\t -> [t ++ ".o"], \_ _ -> return ())),
                  (isSuffixOf ".o", (\t -> [changeSuffix ".o" ".c" t], \_ _ -> return ()))])
 , Just [[("hello", ["hello.o"]), ("hello.o", ["hello.c"])]]
             ~=? fmap getTwoOfTraceRuleRet (traceRule id (Just . (=="hello.c"))  "hello"
                 [(const True, (\t -> [t ++ ".o"], \_ _ -> return ())),
                  (isSuffixOf ".o", (\t -> [changeSuffix ".o" ".c" t], \_ _ -> return ()))])
 ]
