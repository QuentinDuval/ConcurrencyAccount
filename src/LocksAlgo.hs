module LocksAlgo (
   withLocks,
   withTryLocks,
) where

import Control.Concurrent.RLock as RLock
import Control.Exception
import Control.Monad.ListM


-- | Surrounds an IO action with critical sections
withLocks :: [RLock] -> IO a -> IO a
withLocks xs f = foldr RLock.with f xs


-- | Surrounds an IO action with try locks
withTryLocks :: [RLock] -> IO a -> IO a
withTryLocks locks f = do
   r <- withTryLocks' locks f
   case r of
      Left rs -> return rs
      Right l -> RLock.wait l >> withTryLocks locks f


withTryLocks' :: [RLock] -> IO a -> IO (Either a RLock)
withTryLocks' locks f = do
   (locked, unlocked) <- spanM RLock.tryAcquire locks
   finally
      (if null unlocked
         then (return . Left) =<< f 
         else (return . Right) (head unlocked))
      (mapM_ RLock.release locked)

  
