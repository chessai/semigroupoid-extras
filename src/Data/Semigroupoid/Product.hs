{-# LANGUAGE GADTs, PolyKinds, DataKinds, MultiParamTypeClasses #-}
-----------------------------------------------------------------------------
-- |
-- Copyright   :  (C) 2011-2015 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
--
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  provisional
-- Portability :  polykinds
--
----------------------------------------------------------------------------

module Data.Semigroupoid.Product
  ( Product(..)
  , distributeDualProduct
  , factorDualProduct
  ) where

import Data.Semigroupoid
import Data.Semigroupoid.Ob
import Data.Semigroupoid.Dual
import Data.Groupoid

data Product j k a b where
  Pair :: j a b -> k a' b' -> Product j k '(a,a') '(b,b')

instance (Semigroupoid j, Semigroupoid k) => Semigroupoid (Product j k) where
  Pair w x `o` Pair y z = Pair (w `o` y) (x `o` z)

instance (Groupoid j, Groupoid k) => Groupoid (Product j k) where
  inv (Pair w x) = Pair (inv w) (inv x)

distributeDualProduct :: Dual (Product j k) a b -> Product (Dual j) (Dual k) a b
distributeDualProduct (Dual (Pair l r)) = Pair (Dual l) (Dual r)

factorDualProduct :: Product (Dual j) (Dual k) a b -> Dual (Product j k) a b
factorDualProduct (Pair (Dual l) (Dual r)) = Dual (Pair l r)

instance (Ob l a, Ob r b) => Ob (Product l r) '(a,b) where
  semiid = Pair semiid semiid
