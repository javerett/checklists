module Api.Link exposing (..)

import Api.Generated exposing (Location, Request, ChecklistHeader, locationDecoder, requestDecoder, checklistHeaderDecoder)
import Http
import Json.Decode as D

getLocationsAction : (Result Http.Error (List Location) -> msg) -> Cmd msg
getLocationsAction msg =
  ihpRequest
    { method = "GET"
    , headers = []
    , url = "/Locations"
    , body = Http.emptyBody
    , expect = Http.expectJson msg (D.list locationDecoder)
    }

getRequestsAction : (Result Http.Error (List Request) -> msg) -> Cmd msg
getRequestsAction msg =
  ihpRequest
    { method = "GET"
    , headers = []
    , url = "/Requests"
    , body = Http.emptyBody
    , expect = Http.expectJson msg (D.list requestDecoder)
    }

getChecklistHeadersAction : (Result Http.Error (List ChecklistHeader) -> msg) -> Cmd msg
getChecklistHeadersAction msg =
  ihpRequest
    { method = "GET"
    , headers = []
    , url = "/Checklists"
    , body = Http.emptyBody
    , expect = Http.expectJson msg (D.list checklistHeaderDecoder)
    }

ihpRequest :
  { method : String
  , headers : List Http.Header
  , url : String
  , body : Http.Body
  , expect : Http.Expect msg
  }
  -> Cmd msg
ihpRequest { method, headers, url, body, expect } =
    Http.request
        { method = method
        , headers =
            [ Http.header "Accept" "application/json" ] ++ headers
        , url = url
        , body = body
        , expect = expect
        , timeout = Nothing
        , tracker = Nothing
        }
