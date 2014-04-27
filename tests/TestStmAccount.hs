module TestStmAccount (runTest) where

import StmAccount
import qualified StmAccountAlgo
import TestScenario


-- | Test case

runTest :: Int -> IO ()
runTest = transferTest create

instance Transferable Account where
   transfer = StmAccountAlgo.transfer

instance Observable Account where
   observe = StmAccountAlgo.observe

