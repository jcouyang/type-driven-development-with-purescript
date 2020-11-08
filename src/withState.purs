module WithState where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, runAff_)
import Effect.Console (errorShow)
import Effect.Exception (Error)
import Signal (runSignal, (<~))
import Signal.Channel (Channel, subscribe)

type SetState a = (a -> a) -> Effect Unit
doNothing :: forall a . Aff (a -> a)
doNothing = pure identity

subscribeChannel :: forall a. Channel (Aff (a -> a)) -> a -> SetState a -> Effect Unit
subscribeChannel ch state setState = runSignal $ runAff_ updateState <~ subscribe ch
  where
    updateState:: Either Error (a -> a) -> Effect Unit
    updateState (Right a) = setState a
    updateState (Left e) = errorShow e
