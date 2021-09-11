{-# language DeriveAnyClass #-}

module Web.JsonTypes where

import Generated.Types
import IHP.ControllerPrelude
import qualified Data.Aeson as Aeson
import GHC.Generics (Generic)
import qualified Generics.SOP as SOP
import Language.Haskell.To.Elm
import Application.Lib.DerivingViaElm ( ElmType(..) )

data DecoratedRequest = DecoratedRequest
  { baseRequest :: Request
  , locationName :: Text
  }

data LocationJSON = LocationJSON
  { id :: Text
  , name :: Text
  , address :: Text
  } deriving ( Generic
             , SOP.Generic
             , SOP.HasDatatypeInfo
             )
    deriving ( Aeson.ToJSON
             , Aeson.FromJSON
             , HasElmType
             , HasElmDecoder Aeson.Value
             , HasElmEncoder Aeson.Value)
    via ElmType "Api.Generated.Location" LocationJSON

data RequestJSON = RequestJSON
  { id :: Text
  , location_name :: Text
  , location_id :: Text
  , description :: Text
  } deriving ( Generic
             , SOP.Generic
             , SOP.HasDatatypeInfo
             )
    deriving ( Aeson.ToJSON
             , Aeson.FromJSON
             , HasElmType
             , HasElmDecoder Aeson.Value
             , HasElmEncoder Aeson.Value)
    via ElmType "Api.Generated.Request" RequestJSON

data ChecklistJSON = ChecklistJSON
  { id :: Text
  , request :: Text
  , name :: Text
  , items :: [ChecklistItemJSON]
  } deriving ( Generic
             , SOP.Generic
             , SOP.HasDatatypeInfo
             )
    deriving ( Aeson.ToJSON
             , Aeson.FromJSON
             , HasElmType
             , HasElmDecoder Aeson.Value
             , HasElmEncoder Aeson.Value)
    via ElmType "Api.Generated.Checklist" ChecklistJSON

data ChecklistItemJSON = ChecklistItemJSON
  { id :: Text
  , checklist :: Text
  , question :: Text
  , responseType :: Int
  , responseValue :: Text
  } deriving ( Generic
             , SOP.Generic
             , SOP.HasDatatypeInfo
             )
    deriving ( Aeson.ToJSON
             , Aeson.FromJSON
             , HasElmType
             , HasElmDecoder Aeson.Value
             , HasElmEncoder Aeson.Value)
    via ElmType "Api.Generated.ChecklistItem" ChecklistItemJSON

data ChecklistHeaderJSON = ChecklistHeaderJSON
  { id :: Text
  , request :: Text
  , name :: Text
  } deriving ( Generic
             , SOP.Generic
             , SOP.HasDatatypeInfo
             )
    deriving ( Aeson.ToJSON
             , Aeson.FromJSON
             , HasElmType
             , HasElmDecoder Aeson.Value
             , HasElmEncoder Aeson.Value)
    via ElmType "Api.Generated.ChecklistHeader" ChecklistHeaderJSON

locationToJSON :: Location -> LocationJSON
locationToJSON loc = LocationJSON
  { id = show $ get #id loc
  , name = get #name loc
  , address = get #address loc
  }

requestToJSON :: DecoratedRequest -> RequestJSON
requestToJSON req = RequestJSON
  { id = show $ get #id $ baseRequest req
  , location_id = show $ get #location $ baseRequest req
  , location_name = locationName req
  , description = get #description $ baseRequest req
  }

checklistToJSON :: Checklist -> [ChecklistItem] -> ChecklistJSON
checklistToJSON checklist items = ChecklistJSON
  { id = show $ get #id checklist
  , request = show $ get #request checklist
  , name = get #name checklist
  , items = map checklistItemToJSON items
  }

checklistHeaderToJSON :: Checklist -> ChecklistHeaderJSON
checklistHeaderToJSON checklist = ChecklistHeaderJSON
  { id = show $ get #id checklist
  , request = show $ get #request checklist
  , name = get #name checklist
  }

checklistItemToJSON :: ChecklistItem -> ChecklistItemJSON
checklistItemToJSON item = ChecklistItemJSON
  { id = show $ get #id item
  , checklist = show $ get #checklist item
  , question = get #question item
  , responseType = get #responseType item
  , responseValue = get #responseValue item
  }
