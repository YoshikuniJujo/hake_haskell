module Development.Hake.DirectoryTools (
  maybeGetModificationTime
, doesNotExistOrOldThan
) where

import System.Directory    (doesFileExist, getModificationTime)
import System.Time         (ClockTime)
import Control.Monad.Tools (ifM)
import Control.Applicative (liftA2, (<$>))
import Data.Function       (on)

maybeGetModificationTime :: FilePath -> IO (Maybe ClockTime)
maybeGetModificationTime fn
  = ifM (doesFileExist fn)
        (Just <$> getModificationTime fn)
	(return Nothing)

doesNotExistOrOldThan :: FilePath -> FilePath -> IO Bool
doesNotExistOrOldThan dfn sfn
  = on (liftA2 (<)) maybeGetModificationTime dfn sfn
