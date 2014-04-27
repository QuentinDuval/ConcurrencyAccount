module StmAccount (
   Account,
   create,
   getId,
   getBalance,
   deposit,
) where

import Control.Concurrent.STM


-- | STM Account
data Account = Account {
   _uid     :: Int,
   _balance :: TVar Int
};

-- | Create a new portfolio
create :: Int -> IO Account
create id = do
   balance <- atomically $ newTVar 0
   return $ Account id balance

-- | Deposit some money into the account
deposit :: Account -> Int -> STM ()
deposit acc amount = do
   b <- getBalance acc
   writeTVar (_balance acc) (b + amount)

-- | Id accessor
getId :: Account -> Int
getId = _uid

-- | Balance accessor
getBalance :: Account -> STM Int
getBalance acc = readTVar (_balance acc)
