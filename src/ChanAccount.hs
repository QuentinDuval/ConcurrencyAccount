module ChanAccount(
   Account,
   create, deposit,
   getBalance, getId
)where

import Control.Concurrent
import Control.Concurrent.STM
import Control.Concurrent.STM.TChan


-- | STM Account
data Account = Account {
   _uid     :: Int,
   _send    :: AccountMessage -> STM ()
};

data AccountMessage = Deposit Int | GetBalance (MVar Int)
data AccountI = AccountI Int;


-- | Create a new portfolio
create :: Int -> IO Account
create id = do
   chan <- atomically newTChan
   _ <- forkIO $ worker chan
   return $ Account id (writeTChan chan)

worker :: TChan AccountMessage -> IO ()
worker ch = loop 0 where
   loop balance = do
      m <- atomically (readTChan ch)
      case m of
         Deposit amount -> loop $! balance + amount
         GetBalance var -> putMVar var balance >> loop balance


-- | Deposit some money into the account
deposit :: Account -> Int -> STM ()
deposit acc amount = _send acc $ Deposit amount

-- | Id accessor
getId :: Account -> Int
getId = _uid

-- | Balance accessor
getBalance :: Account -> MVar Int -> STM ()
getBalance acc out = _send acc $ GetBalance out

