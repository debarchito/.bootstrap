module Main (main) where

import {{name:P}}Lib qualified (someFunc)

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  {{name:P}}Lib.someFunc
