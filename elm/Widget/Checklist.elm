module Widget.Checklist exposing (..)

import Api.Generated exposing (Checklist, ChecklistItem)
import Html exposing (..)
import Html.Attributes exposing (..)

type alias Model = Checklist

init : Checklist -> ( Model, Cmd msg )
init loc = ( loc, Cmd.none )

initialCmd : Cmd Msg
initialCmd = Cmd.none

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

type Msg
  = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )

view : Model -> Html Msg
view checklist = div [] (List.map viewChecklistItem checklist.items)

viewChecklistItem : ChecklistItem -> Html msg
viewChecklistItem item = div []
  [ input [ type_ "checkbox" ] []
  , text <| item.question
  ]
