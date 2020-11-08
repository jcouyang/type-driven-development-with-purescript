{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "type-driven-development-with-purescript"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "prelude"
  , "psci-support"
  , "signal"
  , "simple-json"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
