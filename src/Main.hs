module Main where

import Data.Time
import qualified TestChanAccount
import qualified TestStmAccount
import qualified TestSyncAccount


main :: IO ()
main = do
   putStrLn "Run all tests:"
   mapM_ (\(s,t) -> putStrLn s >> runTest 1000 t) allTests


-- | All implementations to test
allTests :: [(String, Int -> IO ())]
allTests = [("Unsynchronized transfer:",  TestSyncAccount.runUnsyncTest),
            ("Ordered lock transfer:",    TestSyncAccount.runOrderTest),
            ("Try lock transfer:",        TestSyncAccount.runTryTest),
            ("STM transfer:",             TestStmAccount.runTest),
            ("STM channel:",              TestChanAccount.runTest)]


-- | Run a test and time it
runTest :: Int -> (Int -> IO a) -> IO a
runTest iter f = do
   start <- getCurrentTime
   r <- f iter
   stop <- getCurrentTime
   print $ diffUTCTime stop start
   return r
