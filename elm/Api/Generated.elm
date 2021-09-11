module Api.Generated exposing (..)

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


type Widget 
    = LocationWidget Location
    | LocationGridWidget 
    | RequestWidget Request
    | RequestGridWidget 
    | ChecklistWidget Checklist
    | ChecklistGridWidget 


widgetEncoder : Widget -> Json.Encode.Value
widgetEncoder a =
    case a of
        LocationWidget b ->
            Json.Encode.object [ ("tag" , Json.Encode.string "LocationWidget")
            , ("contents" , locationEncoder b) ]
        
        LocationGridWidget ->
            Json.Encode.object [ ("tag" , Json.Encode.string "LocationGridWidget") ]
        
        RequestWidget b ->
            Json.Encode.object [ ("tag" , Json.Encode.string "RequestWidget")
            , ("contents" , requestEncoder b) ]
        
        RequestGridWidget ->
            Json.Encode.object [ ("tag" , Json.Encode.string "RequestGridWidget") ]
        
        ChecklistWidget b ->
            Json.Encode.object [ ("tag" , Json.Encode.string "ChecklistWidget")
            , ("contents" , checklistEncoder b) ]
        
        ChecklistGridWidget ->
            Json.Encode.object [ ("tag" , Json.Encode.string "ChecklistGridWidget") ]


widgetDecoder : Json.Decode.Decoder Widget
widgetDecoder =
    Json.Decode.field "tag" Json.Decode.string |>
    Json.Decode.andThen (\a -> case a of
        "LocationWidget" ->
            Json.Decode.succeed LocationWidget |>
            Json.Decode.Pipeline.required "contents" locationDecoder
        
        "LocationGridWidget" ->
            Json.Decode.succeed LocationGridWidget
        
        "RequestWidget" ->
            Json.Decode.succeed RequestWidget |>
            Json.Decode.Pipeline.required "contents" requestDecoder
        
        "RequestGridWidget" ->
            Json.Decode.succeed RequestGridWidget
        
        "ChecklistWidget" ->
            Json.Decode.succeed ChecklistWidget |>
            Json.Decode.Pipeline.required "contents" checklistDecoder
        
        "ChecklistGridWidget" ->
            Json.Decode.succeed ChecklistGridWidget
        
        _ ->
            Json.Decode.fail "No matching constructor")


type alias Location  =
    { id : String, name : String, address : String }


locationEncoder : Location -> Json.Encode.Value
locationEncoder a =
    Json.Encode.object [ ("id" , Json.Encode.string a.id)
    , ("name" , Json.Encode.string a.name)
    , ("address" , Json.Encode.string a.address) ]


locationDecoder : Json.Decode.Decoder Location
locationDecoder =
    Json.Decode.succeed Location |>
    Json.Decode.Pipeline.required "id" Json.Decode.string |>
    Json.Decode.Pipeline.required "name" Json.Decode.string |>
    Json.Decode.Pipeline.required "address" Json.Decode.string


type alias Request  =
    { id : String
    , location_name : String
    , location_id : String
    , description : String }


requestEncoder : Request -> Json.Encode.Value
requestEncoder a =
    Json.Encode.object [ ("id" , Json.Encode.string a.id)
    , ("location_name" , Json.Encode.string a.location_name)
    , ("location_id" , Json.Encode.string a.location_id)
    , ("description" , Json.Encode.string a.description) ]


requestDecoder : Json.Decode.Decoder Request
requestDecoder =
    Json.Decode.succeed Request |>
    Json.Decode.Pipeline.required "id" Json.Decode.string |>
    Json.Decode.Pipeline.required "location_name" Json.Decode.string |>
    Json.Decode.Pipeline.required "location_id" Json.Decode.string |>
    Json.Decode.Pipeline.required "description" Json.Decode.string


type alias Checklist  =
    { id : String, request : String, name : String, items : List ChecklistItem }


checklistEncoder : Checklist -> Json.Encode.Value
checklistEncoder a =
    Json.Encode.object [ ("id" , Json.Encode.string a.id)
    , ("request" , Json.Encode.string a.request)
    , ("name" , Json.Encode.string a.name)
    , ("items" , Json.Encode.list checklistItemEncoder a.items) ]


checklistDecoder : Json.Decode.Decoder Checklist
checklistDecoder =
    Json.Decode.succeed Checklist |>
    Json.Decode.Pipeline.required "id" Json.Decode.string |>
    Json.Decode.Pipeline.required "request" Json.Decode.string |>
    Json.Decode.Pipeline.required "name" Json.Decode.string |>
    Json.Decode.Pipeline.required "items" (Json.Decode.list checklistItemDecoder)


type alias ChecklistItem  =
    { id : String
    , checklist : String
    , question : String
    , responseType : Int
    , responseValue : String }


checklistItemEncoder : ChecklistItem -> Json.Encode.Value
checklistItemEncoder a =
    Json.Encode.object [ ("id" , Json.Encode.string a.id)
    , ("checklist" , Json.Encode.string a.checklist)
    , ("question" , Json.Encode.string a.question)
    , ("responseType" , Json.Encode.int a.responseType)
    , ("responseValue" , Json.Encode.string a.responseValue) ]


checklistItemDecoder : Json.Decode.Decoder ChecklistItem
checklistItemDecoder =
    Json.Decode.succeed ChecklistItem |>
    Json.Decode.Pipeline.required "id" Json.Decode.string |>
    Json.Decode.Pipeline.required "checklist" Json.Decode.string |>
    Json.Decode.Pipeline.required "question" Json.Decode.string |>
    Json.Decode.Pipeline.required "responseType" Json.Decode.int |>
    Json.Decode.Pipeline.required "responseValue" Json.Decode.string


type alias ChecklistHeader  =
    { id : String, request : String, name : String }


checklistHeaderEncoder : ChecklistHeader -> Json.Encode.Value
checklistHeaderEncoder a =
    Json.Encode.object [ ("id" , Json.Encode.string a.id)
    , ("request" , Json.Encode.string a.request)
    , ("name" , Json.Encode.string a.name) ]


checklistHeaderDecoder : Json.Decode.Decoder ChecklistHeader
checklistHeaderDecoder =
    Json.Decode.succeed ChecklistHeader |>
    Json.Decode.Pipeline.required "id" Json.Decode.string |>
    Json.Decode.Pipeline.required "request" Json.Decode.string |>
    Json.Decode.Pipeline.required "name" Json.Decode.string