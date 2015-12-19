module AWS.S3 
  ( getObject
  , AWS()
  , putObject
  , S3GetObject(..)
  , S3PutObject(..)
  ) where

import Prelude

import Control.Monad.Eff
import Control.Monad.Aff
import Control.Monad.Eff.Exception
import Data.Foreign
import Data.Foreign.Class

type Bucket = String
type Key = String
type Body = String

data S3GetObject = S3GetObject { body :: String
                               }
data S3PutObject = S3PutObject {}

instance s3GetObjectIsForeign :: IsForeign S3GetObject where
  read value = do
    body <- readProp "Body" value
    return $ S3GetObject { body: body }

instance s3PutObjectIsForeign :: IsForeign S3PutObject where
  read value = do
    return $ S3PutObject {}
    
foreign import data AWS :: !

foreign import getObjectAff :: forall e. (Foreign -> Eff (aws :: AWS | e) Unit) -> (Error -> Eff (aws :: AWS | e) Unit) -> Bucket -> Key -> Eff (aws :: AWS | e) Unit
foreign import putObjectAff :: forall e. (Foreign -> Eff (aws :: AWS | e) Unit) -> (Error -> Eff (aws :: AWS | e) Unit) -> Bucket -> Key -> Body -> Eff (aws :: AWS | e) Unit

getObject :: forall e. Bucket -> Key -> Aff (aws :: AWS | e) (F S3GetObject)
getObject b k = do
   resp <- makeAff (\error success -> getObjectAff success error b k)
   return $ read resp
   
putObject :: forall e. Bucket -> Key -> Body -> Aff (aws :: AWS | e) (F S3PutObject)
putObject b k s = do
   resp <- makeAff (\error success -> putObjectAff success error b k s)
   return $ read resp