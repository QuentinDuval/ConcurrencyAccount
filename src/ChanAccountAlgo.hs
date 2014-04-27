module ChanAccountAlgo where

import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad
import ChanAccount


-- | Atomic transfer between two accounts
transfer :: Int -> Account -> Account -> IO ()
transfer amount src dst =
   atomically $ do
      deposit src (-amount)
      deposit dst amount


-- | Atomic observation of the accounts
observe :: [Account] -> IO [Int]
observe accs = do
   results <- mapM (const newEmptyMVar) accs
   atomically $ zipWithM getBalance accs results
   mapM takeMVar results

