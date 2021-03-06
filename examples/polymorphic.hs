{-# OPTIONS_GHC -fno-warn-name-shadowing #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}
{-# LANGUAGE ConstraintKinds, DataKinds, NoImplicitPrelude #-}
{-# LANGUAGE OverloadedLabels, TypeOperators               #-}
module Example where
import Algebra.Algorithms.Groebner
import Algebra.Prelude
import Algebra.Ring.Polynomial.Labeled

default (Int)


x, y, f, f1, f2 :: Polynomial (Ratio Integer) 2
x = var 0
y = var 1
f = x^2 * y + x * y^2 + y^2
f1 = x * y - 1
f2 = y^2 - 1

type LexPolynomial r n = OrderedPolynomial r Lex n
type XYABCS = (LabPolynomial (Polynomial (Ratio Integer) 6) '["x", "y", "a", "b", "c", "S"])
type ABCS = (LabPolynomial (Polynomial (Ratio Integer) 4) '["a", "b", "c", "S"])

s :: ABCS
s = var 3

heronIdeal :: Ideal XYABCS
heronIdeal = toIdeal [ 2 * s - #a * #y
                     , #b^2 - (#x^2 + #y^2)
                     , #c^2 - ( (#a -  #x) ^ 2 + #y^2)
                     ]
  where
    s = last vars
    -- Due to the current limitation of @OverloadedLabels@ extension,
    -- we cannot use label starting with a CAPITAL LETTER.
    -- so we have to do this.


main :: IO ()
main = do
  putStrLn $ unwords ["(" ++ show (x + 1) ++ ")^2", "="
                     , show $ (x + 1) ^2 ]
  putStrLn $ unwords ["(" ++ show (x + 1) ++ ")(" ++ show (x - 1) ++ ")", "="
                     , show $ (x + 1) * (x - 1) ]
  putStrLn $ unwords ["(" ++ show (x - 1) ++ ")(" ++ show (y^2 + y - 1) ++ ")", "="
                     , show $ (x - 1) * (y^2 + y- 1) ]
  putStrLn ""
  putStrLn "*** deriving Heron's formula ***"
  putStrLn "Area of triangles can be determined from following equations:"
  putStrLn "\t2S = ay, b^2 = x^2 + y^2, c^2 = (a-x)^2 + y^2"
  putStrLn ", where a, b, c and S stands for three lengths of the traiangle and its area, "
  putStrLn "and (x, y) stands for the coordinate of one of its vertices"
  putStrLn "(other two vertices are assumed to be on the origin and x-axis)."
  putStrLn "Erasing x and y from the equations above, we can get Heron's formula."
  putStrLn "Using elimination ideal, this can be automatically solved."
  putStrLn "We calculate this with theory of Groebner basis with respect to 'lex'."
  putStrLn "This might take a while. please wait..."
  print $ toABCSIdeal (sTwo `thEliminationIdeal` heronIdeal)
  putStrLn "The ideal has just one polynomial `f' as its only generator."
  putStrLn "Solving the equation `f = 0' assuming S > 0, we can get Heron's formula."
  putStrLn ""
  putStrLn "Let's use nother elimination type. We choose Grevlex x Grevlex: "
  print $ toABCSIdeal $
    thEliminationIdealWith (eliminationOrder sTwo sFour) sTwo heronIdeal
  putStrLn "And weighted order:"
  print $ toABCSIdeal $
    thEliminationIdealWith (weightedEliminationOrder sTwo) sTwo heronIdeal

toABCSIdeal :: Ideal (OrderedPolynomial (Fraction Integer) Grevlex (6 :-. 2)) -> Ideal (LabPolynomial (Polynomial (Ratio Integer) 4) '["a", "b", "c", "S"])
toABCSIdeal = mapIdeal (flip asTypeOf s . injectVars)

sFour :: SNat 4
sFour = sing

sTwo :: SNat 2
sTwo = sing
