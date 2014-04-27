module SyncAccount(
   Account,
   create,
   getId,
   getBalance,
   deposit,
   getLock,
) where

import Control.Concurrent.RLock as RLock
import Data.IORef


-- | Synchronized portfolio
data Account = Account {
   _lock    :: RLock,
   _uid     :: Int,
   _balance :: IORef Int
};


-- | Create a new portfolio
create :: Int -> IO Account
create id = do
   lock <- RLock.new
   balance <- newIORef 0
   return $ Account lock id balance

-- | Deposit some money into the account
deposit :: Account -> Int -> IO ()
deposit acc amount =
   RLock.with(_lock acc) $ do
      b <- readIORef (_balance acc)
      writeIORef (_balance acc) (b + amount)

-- | Id accessor
getId :: Account -> Int
getId = _uid

-- | Balance accessor
getBalance :: Account -> IO Int
getBalance acc =
   RLock.with(_lock acc) $
      readIORef (_balance acc)

-- | Access object internal lock
getLock :: Account -> RLock
getLock = _lock
                      
