module Development.Hake.Core (

  traceRule
, applyRule

) where

import System.Directory          (doesFileExist)
import Development.Hake.DirectoryTools (maybeGetModificationTime)
import Control.Monad.Trans       (lift)
import Control.Monad.Tools       (ifM)
import Control.Applicative       ((<$>), liftA2)
import Control.Applicative.Tools ((<.>))
import Control.Arrow             (second)
import Data.List.Tools           (mulLists)
import Development.Hake.Types    (RuleRet, RuleInner, CommandIO)

traceRule ::
  (Monad m, Functor m) =>
  (m [[ RuleRet ]] -> m [[ RuleRet ]]) -> (FilePath -> m Bool) ->
  FilePath -> [ RuleInner ] -> m [[ RuleRet ]]
traceRule opt tst trgt rls
  = case myLookup trgt rls of
      []    -> ifM (tst trgt) (return [[]]) (return [])
      finds -> do
        optional <- ifM (tst trgt) (return [[]]) (return [])
        fmap (++ optional) $ concat <.> flip mapM finds
	                   $ \((tToS, tsToCmds), restRls) -> do
          let srcs = tToS trgt
	      cmds = tsToCmds trgt srcs
          obtainedRls <- mapM (opt . flip (traceRule opt tst) restRls) srcs
	  return $ map ( (( trgt, (srcs, cmds) ):) . concat )
	         $ mulLists obtainedRls

myLookup :: a -> [ (a -> Bool, b) ] -> [ (b, [ (a -> Bool, b) ]) ]
myLookup _ []            = []
myLookup x (pair@(p, y):rest)
  | p x       = (y, rest) : ( second (pair:) <$> myLookup x rest )
  | otherwise =               second (pair:) <$> myLookup x rest

applyRule :: RuleRet -> CommandIO ()
applyRule (src, (dsts, cmd))
  = ifM ( lift $ isOldThanSomeOf src dsts ) cmd ( return () )

isOldThanSomeOf :: FilePath -> [FilePath] -> IO Bool
isOldThanSomeOf dfn sfns =
  flip (ifM $ doesFileExist dfn) (return True) $
    liftA2 ((myOr .) . map . (<)) (maybeGetModificationTime dfn)
                                  (mapM maybeGetModificationTime sfns)
    where
      -- for task like "clean"
      myOr [] = True
      myOr bs = or bs
