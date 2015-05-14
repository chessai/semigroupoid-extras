{-# LANGUAGE CPP, GADTs, EmptyDataDecls, PolyKinds, DataKinds, MultiParamTypeClasses #-}
-----------------------------------------------------------------------------
-- |
-- Copyright   :  (C) 2011-2015 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
--
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  provisional
-- Portability :  portable
--
----------------------------------------------------------------------------

module Data.Semigroupoid.Coproduct
  ( Coproduct(..), distributeDualCoproduct, factorDualCoproduct) where

import Data.Semigroupoid
import Data.Semigroupoid.Dual
import Data.Semigroupoid.Ob
import Data.Groupoid

data Coproduct j k a b where
  L :: j a b -> Coproduct j k (Left a) (Left b)
  R :: k a b -> Coproduct j k (Right a) (Right b)

instance (Semigroupoid j, Semigroupoid k) => Semigroupoid (Coproduct j k) where
  L f `o` L g = L (f `o` g)
  R f `o` R g = R (f `o` g)
  _ `o` _ = error "GADT fail"

instance (Groupoid j, Groupoid k) => Groupoid (Coproduct j k) where
  inv (L f) = L (inv f)
  inv (R f) = R (inv f)

instance (Ob l a, Semigroupoid r)  => Ob (Coproduct l r) (Left a) where
  semiid = L semiid

instance (Semigroupoid l, Ob r a) => Ob (Coproduct l r) (Right a) where
  semiid = R semiid

distributeDualCoproduct :: Dual (Coproduct j k) a b -> Coproduct (Dual j) (Dual k) a b
distributeDualCoproduct (Dual (L l)) = L (Dual l)
distributeDualCoproduct (Dual (R r)) = R (Dual r)

factorDualCoproduct :: Coproduct (Dual j) (Dual k) a b -> Dual (Coproduct j k) a b
factorDualCoproduct (L (Dual l)) = Dual (L l)
factorDualCoproduct (R (Dual r)) = Dual (R r)
