module TestChanAccount (runTest) where

import ChanAccount
import qualified ChanAccountAlgo
import TestScenario


-- | Test case

runTest :: Int -> IO ()
runTest = transferTest create

instance Transferable Account where
   transfer = ChanAccountAlgo.transfer

instance Observable Account where
   observe = ChanAccountAlgo.observe

