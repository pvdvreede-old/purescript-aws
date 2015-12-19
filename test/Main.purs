module Test.Main where

import Prelude
import Test.Unit
import Control.Monad.Trans
import Test.Unit.Console
import Control.Monad.Eff
import Control.Monad.Aff
import Control.Monad.Eff.Class
import Data.Either
import AWS.S3

testGetObject :: forall e. Aff (aws :: AWS | e) String
testGetObject = do
    obj <- getObject "MyBucket" "Path"
    case obj of
      Right (S3GetObject x) -> return x.body
      _                     -> return "Bad request"

main :: Eff (aws :: AWS, testOutput :: TestOutput) Unit
main = runTest do
  test "getObject" $ launchAff do
    actual <- llift $ testGetObject
    assert "works" $ actual == "The body"

  test "putObject" do
    assert "never" $ 1 == 1 