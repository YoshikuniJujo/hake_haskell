module Development.Hake.Tribial (
  ghcMake
, updateFile_
) where

import System.IO              (openFile, hClose, IOMode(WriteMode), hGetLine,
                               IOMode(ReadMode), withFile)
import System.IO.Unsafe       (unsafeInterleaveIO)
import System.Process         (runProcess, waitForProcess)
import System.Exit            (ExitCode(ExitSuccess))
import System.Directory       (doesFileExist)
import Development.Hake.DirectoryTools (doesNotExistOrOldThan)
import Control.Exception      (bracket)
import Control.Monad.Tools    (ifM)
import Control.Applicative    ((<$>))

ghcMake :: String -> FilePath -> IO ExitCode
ghcMake exe dir = do
  let errFile = dir ++ "/" ++ exe ++ ".error"
  ret <- bracket (openFile errFile WriteMode) hClose $ \errH ->
           runProcess "ghc" [ "--make", exe ] (Just dir)
                      Nothing Nothing Nothing (Just errH) >>= waitForProcess
  case ret of
       ExitSuccess -> return ()
       _           -> readFile errFile >>= putStr
  return ret

updateFile_ :: (String -> Maybe String) -> (FilePath -> String) -> FilePath -> FilePath -> IO Bool
updateFile_ gtSrc hdr src dst
  = ifM ( not <$> doesFileExist dst
          `orIO`
          (/= Just src) . gtSrc <$> withFile dst ReadMode (hGetLine)
          `orIO`
          doesNotExistOrOldThan dst src )
      (readFile src >>= writeFile dst . ( (hdr src ++ "\n") ++ ) >> return True )
      (                                                             return False)
  where
  infixr 2 `orIO`
  orIO p1 p2     = do { b1 <- p1; b2 <- unsafeInterleaveIO p2; return $ b1 || b2 }
