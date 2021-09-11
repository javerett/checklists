module Widget.Request exposing (..)

import Api.Generated exposing (Request)
import Html exposing (..)

type alias Model = Request

init : Request -> ( Model, Cmd msg )
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
view loc = div [] [ text "fdsa" ]
