module SyncAccountAlgo where

import Control.Concurrent
import Control.Monad
import Data.List
import LocksAlgo
import SyncAccount


-- | Non atomic operations

dumbTransfer :: Int -> Account -> Account -> IO ()
dumbTransfer amount src dst = do
   deposit src (-amount)
   deposit dst amount

dumbObserve :: [Account] -> IO [Int]
dumbObserve = mapM getBalance


-- | Atomic operations based on ordered locks

compareAcc :: Account -> Account -> Ordering
compareAcc p1 p2 = compare (getId p1) (getId p2)

orderedTransfer :: Int -> Account -> Account -> IO ()
orderedTransfer amount src dst =
   let locks = map getLock $ sortBy compareAcc [src, dst]
   in withLocks locks $ dumbTransfer amount src dst

orderedObserve :: [Account] -> IO [Int]
orderedObserve accs =
   let accs' = sortBy compareAcc accs
       locks = map getLock accs
   in withLocks locks $ mapM getBalance accs'


-- | Atomic operations based on try locks

tryTransfer :: Int -> Account -> Account -> IO ()
tryTransfer amount src dst =
   let locks = map getLock [src, dst]
   in withTryLocks locks $ dumbTransfer amount src dst

tryObverse :: [Account] -> IO [Int]
tryObverse accs =
   let locks = map getLock accs
   in withTryLocks locks $ dumbObserve accs

