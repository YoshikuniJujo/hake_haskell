module HakeModule (
  targets
, moreFile
, deps
) where

import Control.Arrow

targetDependPairs :: [ (String, [ String ]) ]
targetDependPairs = [
   (firstSampleXhtml     , firstSampleXhtmlMoreFile  )
 , (useRuleXhtml         , useRuleXhtmlMoreFile      )
 , (useDefaultXhtml      , useDefaultXhtmlMoreFile   )
 , (useAddDepsXhtml      , useAddDepsXhtmlMoreFile   )
 , (useRuleSSXhtml       , useRuleSSXhtmlMoreFile    )
 , (useRuleVXhtml        , useRuleVXhtmlMoreFile     )
 , (useGetValsXhtml      , useGetValsXhtmlMoreFile   )
 , (fileAgainXhtml       , fileAgainXhtmlMoreFile    )
 , (useGetNewersXhtml    , useGetNewersXhtmlMoreFile )
 , (useHakefileIsXhtml   , useHakefileIsXhtmlMoreFile)
 , (useDelRulesXhtml     , useDelRulesXhtmlMoreFile  )
 , (useModuleXhtml       , useModuleXhtmlMoreFile    )
 , ("use_f_option.xhtml" , [ "myHakefile.hs_use_f_option" ] )
 ]

targets :: [ String ]
targets = map fst targetDependPairs

moreFile :: [ String ]
moreFile = concatMap snd targetDependPairs
   
deps :: [ (String, [String]) ]
deps = map (second ("Variables.hs":)) targetDependPairs

firstSampleXhtml, useRuleXhtml, useDefaultXhtml, useAddDepsXhtml :: String
firstSampleXhtml   = "first_sample.xhtml"
useRuleXhtml       = "use_rule.xhtml"
useDefaultXhtml    = "use_default.xhtml"
useAddDepsXhtml    = "use_addDeps.xhtml"
useRuleSSXhtml     = "use_ruleSS.xhtml"
useRuleVXhtml      = "use_ruleV.xhtml"
useGetValsXhtml    = "use_getVals.xhtml"
fileAgainXhtml     = "file_again.xhtml"
useGetNewersXhtml  = "use_getNewers.xhtml"
useHakefileIsXhtml = "use_hakefileIs.xhtml"
useDelRulesXhtml   = "use_delRules.xhtml"
useModuleXhtml     = "use_module.xhtml"

firstSampleXhtmlMoreFile, useRuleXhtmlMoreFile, useDefaultXhtmlMoreFile :: [ String ]
firstSampleXhtmlMoreFile   = [ "Hakefile_first_sample" ]
useRuleXhtmlMoreFile       = [ "Hakefile_use_rule" , "Hakefile_use_rule_FunSetRaw" ]
useDefaultXhtmlMoreFile    = [ "Hakefile_use_default" ]
useAddDepsXhtmlMoreFile    = [ "Hakefile_use_addDeps" ]
useRuleSSXhtmlMoreFile     = [ "Hakefile_use_ruleSS" ]
useRuleVXhtmlMoreFile      = [ "Hakefile_use_ruleV" ]
useGetValsXhtmlMoreFile    = [ "Hakefile_use_getVals" ]
fileAgainXhtmlMoreFile     = [ "Hakefile_file_again" ]
useGetNewersXhtmlMoreFile  = [ "Hakefile_use_getNewers" ]
useHakefileIsXhtmlMoreFile = [ "Hakefile_use_hakefileIs" ] ++ moreMoreFile
useDelRulesXhtmlMoreFile   = [ "Hakefile_use_delRules" ]
useModuleXhtmlMoreFile     = [ "Hakefile_use_module" ] ++ moreMoreFile2

moreMoreFile = [ "hakeMain.hs_use_hakefileIs", "Variables.hs_use_hakefileIs" ]
moreMoreFile2 = [ "Variables.hs_use_module" ]
