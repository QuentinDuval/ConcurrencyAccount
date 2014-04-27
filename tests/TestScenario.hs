module TestScenario where

import Control.Concurrent.Async
import Control.Monad
import Data.Tuple


-- | Test subject should satisfy these interfaces

class Transferable a where
   transfer :: Int -> a -> a -> IO ()

class Observable a where
   observe  :: [a] -> IO [Int]


{- ^
Test case:
   - Make iter transfer of money between the accounts
   - Make iter observation of the total balance (should stay constant)
   - Sum the absolute value of each observation inconsistencies
-}

transferTest :: (Transferable a, Observable a) => (Int-> IO a) -> Int -> IO ()
transferTest builder iter =
   do accounts <- mapM builder [1..4]
      workers <- forM (buildPairs accounts) $
         async . replicateM_ iter . uncurry (transfer 1)
      
      inconsistencies <- replicateM iter $
         return . abs . sum =<< observe accounts
      
      mapM_ wait workers
      putStrLn $ "Errors: " ++ show (sum inconsistencies)
      print =<< observe accounts


-- | Test utils

buildPairs :: [a] -> [(a, a)]
buildPairs ys = rightCircle ++ map swap rightCircle
   where rightCircle = zip ys (drop 1 $ cycle ys)

