{-# LANGUAGE BangPatterns, TypeFamilies, DataKinds, PolyKinds, TypeApplications, ScopedTypeVariables, TypeInType, ConstraintKinds, TypeOperators, GADTs, UndecidableInstances, StandaloneDeriving, FunctionalDependencies, FlexibleContexts, InstanceSigs, AllowAmbiguousTypes, DeriveAnyClass #-}

module Application.Lib.DerivingViaElm where

import IHP.Prelude
import qualified Data.Aeson as Aeson
import qualified Data.Text as Text
import qualified Generics.SOP as SOP
import GHC.Generics (Generic, Rep)
import qualified Language.Elm.Name as Name
import Language.Haskell.To.Elm

-- This reduces boilerplate when making Haskell types that are serializable to Elm
-- Derived from: https://github.com/folq/haskell-to-elm

newtype ElmType (name :: Symbol) a
  = ElmType a

instance
  (Generic a,
  Aeson.GToJSON Aeson.Zero (Rep a)) =>
  Aeson.ToJSON (ElmType name a)
  where
  toJSON (ElmType a) =
    Aeson.genericToJSON Aeson.defaultOptions
      {Aeson.fieldLabelModifier = dropWhile (== '_')} a

instance
  (Generic a, Aeson.GFromJSON Aeson.Zero (Rep a)) =>
  Aeson.FromJSON (ElmType name a)
  where
  parseJSON =
    fmap ElmType . Aeson.genericParseJSON Aeson.defaultOptions
      {Aeson.fieldLabelModifier = dropWhile (== '_')}

instance
  (SOP.HasDatatypeInfo a,
  SOP.All2 HasElmType (SOP.Code a),
  KnownSymbol name) =>
  HasElmType (ElmType name a)
  where
  elmDefinition =
    Just
      $ deriveElmTypeDefinition @a defaultOptions
          {fieldLabelModifier = dropWhile (== '_')}
      $ fromString $ symbolVal $ Proxy @name

instance
  (SOP.HasDatatypeInfo a,
  HasElmType a,
  SOP.All2 (HasElmDecoder Aeson.Value) (SOP.Code a),
  HasElmType (ElmType name a),
  KnownSymbol name) =>
  HasElmDecoder Aeson.Value (ElmType name a)
  where
  elmDecoderDefinition =
    Just
      $ deriveElmJSONDecoder
        @a
        defaultOptions {fieldLabelModifier =
          dropWhile (== '_')}
        Aeson.defaultOptions {Aeson.fieldLabelModifier =
          dropWhile (== '_')}
      $ Name.Qualified moduleName $ lowerName <> "Decoder"
    where
      Name.Qualified moduleName name =
          fromString $ symbolVal $ Proxy @name
      lowerName =
        Text.toLower (Text.take 1 name) <> Text.drop 1 name

instance
  (SOP.HasDatatypeInfo a,
  HasElmType a,
  SOP.All2 (HasElmEncoder Aeson.Value) (SOP.Code a),
  HasElmType (ElmType name a),
  KnownSymbol name) =>
  HasElmEncoder Aeson.Value (ElmType name a)
  where
  elmEncoderDefinition =
    Just
      $ deriveElmJSONEncoder
        @a
        defaultOptions {fieldLabelModifier =
          dropWhile (== '_')}
        Aeson.defaultOptions {Aeson.fieldLabelModifier =
          dropWhile (== '_')}
      $ Name.Qualified moduleName $ lowerName <> "Encoder"
    where
      Name.Qualified moduleName name =
          fromString
            $ symbolVal
            $ Proxy @name
      lowerName =
        Text.toLower (Text.take 1 name) <> Text.drop 1 name

instance HasElmType Float where
  elmType = "Basics.Float"

instance HasElmEncoder Aeson.Value Float where
  elmEncoder = "Json.Encode.float"

instance HasElmDecoder Aeson.Value Float where
  elmDecoder = "Json.Decode.float"
