module StmAccountAlgo where

import Control.Concurrent.STM
import StmAccount


-- | Atomic transfer between two accounts
transfer :: Int -> Account -> Account -> IO ()
transfer amount src dst =
   atomically $ do
      deposit src (-amount)
      deposit dst amount

-- | Atomic observation of the accounts
observe :: [Account] -> IO [Int]
observe accs = atomically $ mapM getBalance accs
