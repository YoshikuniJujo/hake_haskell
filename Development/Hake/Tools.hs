module Development.Hake.Tools (

  changeSuffix
, orDie
, systemE
, rawSystemE

) where

import System.Exit         (ExitCode(ExitSuccess, ExitFailure), exitWith)
import System.Cmd          (system, rawSystem)
import Control.Monad.Trans (MonadIO, liftIO)
import Data.List           (isSuffixOf)

orDie :: MonadIO m => m ExitCode -> (ExitCode -> String) -> m ()
orDie act msg = do
  ec <- act
  case ec of
    ExitSuccess   -> return ()
    ExitFailure _ -> do liftIO $ putStrLn $ msg ec
                        liftIO $ exitWith ec

changeSuffix :: String -> String -> String -> String
changeSuffix oldSfx newSfx fn
  | isSuffixOf oldSfx fn = take (length fn - length oldSfx) fn ++ newSfx
  | otherwise            = error $ "changeSuffix: " ++ oldSfx ++ " is not suffix of " ++ fn

systemE :: MonadIO m => String -> m ExitCode
systemE cmd = liftIO (putStrLn cmd) >> liftIO (system cmd)

rawSystemE :: MonadIO m => [ String ] -> m ExitCode
rawSystemE []  = error "rawSystemE: command not exist"
rawSystemE cmd = liftIO (putStrLn $ unwords cmd) >> liftIO (rawSystem (head cmd) (tail cmd))
