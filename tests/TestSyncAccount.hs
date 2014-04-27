module TestSyncAccount (
   runUnsyncTest,
   runOrderTest,
   runTryTest,
) where

import Control.Monad
import SyncAccount
import SyncAccountAlgo
import TestScenario


-- | Non atomic operations

instance Transferable Account where
   transfer = dumbTransfer

instance Observable Account where
   observe = dumbObserve

runUnsyncTest :: Int -> IO ()
runUnsyncTest = transferTest create


-- | Atomic operations based on ordered locks

newtype OrderedAccount = OrderedAccount { fromOrdered :: Account }

instance Transferable OrderedAccount where
   transfer amount src dst = orderedTransfer amount (fromOrdered src) (fromOrdered dst)

instance Observable OrderedAccount where
   observe = orderedObserve . map fromOrdered

runOrderTest :: Int -> IO ()
runOrderTest = transferTest $ create >=> (return . OrderedAccount)


-- | Atomic operations based on try locks

newtype TryAccount = TryAccount { fromTry :: Account }

instance Transferable TryAccount where
   transfer amount src dst = tryTransfer amount (fromTry src) (fromTry dst)

instance Observable TryAccount where
   observe = tryObverse . map fromTry

runTryTest :: Int -> IO ()
runTryTest = transferTest $ create >=> (return . TryAccount)

