module Development.Hake.Types (
  Rule
, RuleInner
, Targets
, Sources
, Commands

, TargetRet	-- for Unit Test
, SourcesRet	-- for Unit Test
, CommandIO
, CommandRet
, RuleRet

, MadeFromList

, ruleToRuleInner
, ruleRetToMadeFromList
, getSrcs
, getUpdateStatus
) where

import Control.Monad.Reader (ReaderT, asks)

type Targets   = String -> Bool
type Sources   = String -> SourcesRet
type Commands  = String -> [ String ] -> CommandRet
type Rule      = ( Targets, Sources, Commands )
type RuleInner = ( Targets, (Sources, Commands) )

type TargetRet   = String
type SourcesRet  = [ String ]
type CommandIO   = ReaderT (Bool, MadeFromList) IO
type CommandRet  = CommandIO ()
type RuleRet     = ( TargetRet, (SourcesRet, CommandRet) )

type MadeFromList = [ (FilePath, [FilePath]) ]

getSrcs :: FilePath -> CommandIO [FilePath]
getSrcs fp = asks (maybe [] id . lookup fp . snd)

getUpdateStatus :: CommandIO Bool
getUpdateStatus = asks fst

ruleToRuleInner :: Rule -> RuleInner
ruleToRuleInner ( t, s, c ) = ( t, (s, c) )

ruleRetToMadeFromList :: [ RuleRet ] -> MadeFromList
ruleRetToMadeFromList = map (\(t, (s, _)) -> (t, s))
