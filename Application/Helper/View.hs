{-# language DeriveAnyClass #-}

module Application.Helper.View (
  locationWidget,
  locationGridWidget,
  requestWidget,
  requestGridWidget,
  checklistWidget,
  checklistGridWidget,
  Widget(..)
) where

import IHP.ViewPrelude
import Generated.Types
import Data.Aeson as Aeson
import Web.JsonTypes
import qualified Generics.SOP as SOP
import GHC.Generics
import Language.Haskell.To.Elm

data Widget
  = LocationWidget LocationJSON
  | LocationGridWidget
  | RequestWidget RequestJSON
  | RequestGridWidget
  | ChecklistWidget ChecklistJSON
  | ChecklistGridWidget
  deriving ( Generic
           , Aeson.ToJSON
           , SOP.Generic
           , SOP.HasDatatypeInfo
           )

instance HasElmType Widget where
  elmDefinition =
    Just $ "Api.Generated.Widget"
              |> deriveElmTypeDefinition @Widget
                Language.Haskell.To.Elm.defaultOptions

instance HasElmDecoder Aeson.Value Widget where
  elmDecoderDefinition =
    Just $ "Api.Generated.widgetDecoder"
              |> deriveElmJSONDecoder @Widget
                Language.Haskell.To.Elm.defaultOptions Aeson.defaultOptions

instance HasElmEncoder Aeson.Value Widget where
  elmEncoderDefinition =
    Just $ "Api.Generated.widgetEncoder"
              |> deriveElmJSONEncoder @Widget
                Language.Haskell.To.Elm.defaultOptions Aeson.defaultOptions

locationWidget :: Location -> Html
locationWidget loc = [hsx|
  <div data-flags={encode $ LocationWidget $ locationToJSON loc} class="elm"></div>
|]

locationGridWidget :: Html
locationGridWidget = [hsx|
  <div data-flags={encode $ LocationGridWidget} class="elm"></div>
|]

requestWidget :: Text -> Request -> Html
requestWidget loc req = [hsx|
  <div data-flags={encode $ RequestWidget $ requestToJSON $ DecoratedRequest req loc} class="elm"></div>
|]

requestGridWidget :: Html
requestGridWidget = [hsx|
  <div data-flags={encode $ RequestGridWidget} class="elm"></div>
|]

checklistWidget :: Checklist -> [ChecklistItem] -> Html
checklistWidget checklist items = [hsx|
  <div data-flags={encode $ ChecklistWidget $ checklistToJSON checklist items} class="elm"></div>
|]

checklistGridWidget :: Html
checklistGridWidget = [hsx|
  <div data-flags={encode $ ChecklistGridWidget} class="elm"></div>
|]
