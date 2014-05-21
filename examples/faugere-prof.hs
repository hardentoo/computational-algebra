module Main where
import Algebra.Algorithms.Faugere4
import Algebra.Ring.Polynomial
import Control.DeepSeq
import Data.Type.Natural           (sFour)

main :: IO ()
main = faugere4 optimalStrategy (cyclic sFour) `deepseq` return ()