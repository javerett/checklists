module Main exposing (main)

import Api.Generated exposing (Location, Request, Checklist, Widget(..), locationDecoder, widgetDecoder)
import Browser
import Html exposing (..)
import Http
import Json.Decode as D

import ErrorView exposing (httpErrorView)
import Widget.Location
import Widget.LocationGrid
import Widget.Request
import Widget.RequestGrid
import Widget.Checklist
import Widget.ChecklistGrid

type Model
  = LocationModel Widget.Location.Model
  | LocationGridModel Widget.LocationGrid.Model
  | RequestModel Widget.Request.Model
  | RequestGridModel Widget.RequestGrid.Model
  | ChecklistModel Widget.Checklist.Model
  | ChecklistGridModel Widget.ChecklistGrid.Model
  | ErrorModel String

type Msg
  = LocationMsg Widget.Location.Msg
  | LocationGridMsg Widget.LocationGrid.Msg
  | RequestMsg Widget.Request.Msg
  | RequestGridMsg Widget.RequestGrid.Msg
  | ChecklistMsg Widget.Checklist.Msg
  | ChecklistGridMsg Widget.ChecklistGrid.Msg
  | ErrorMsg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case ( msg, model ) of
    ( LocationMsg subMsg, LocationModel subModel ) -> Widget.Location.update subMsg subModel |> updateWith LocationModel LocationMsg model
    ( LocationGridMsg subMsg, LocationGridModel subModel ) -> Widget.LocationGrid.update subMsg subModel |> updateWith LocationGridModel LocationGridMsg model
    ( RequestMsg subMsg, RequestModel subModel ) -> Widget.Request.update subMsg subModel |> updateWith RequestModel RequestMsg model
    ( RequestGridMsg subMsg, RequestGridModel subModel ) -> Widget.RequestGrid.update subMsg subModel |> updateWith RequestGridModel RequestGridMsg model
    ( ChecklistMsg subMsg, ChecklistModel subModel ) -> Widget.Checklist.update subMsg subModel |> updateWith ChecklistModel ChecklistMsg model
    ( ChecklistGridMsg subMsg, ChecklistGridModel subModel ) -> Widget.ChecklistGrid.update subMsg subModel |> updateWith ChecklistGridModel ChecklistGridMsg model
    ( ErrorMsg, ErrorModel _ ) -> ( model, Cmd.none )
    _ -> ( model, Cmd.none )

updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) = ( toModel subModel, Cmd.map toMsg subCmd )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

view : Model -> Html Msg
view model =
  case model of
    LocationModel subModel -> Html.map LocationMsg (Widget.Location.view subModel)
    LocationGridModel subModel -> Html.map LocationGridMsg (Widget.LocationGrid.view subModel)
    RequestModel subModel -> Html.map RequestMsg (Widget.Request.view subModel)
    RequestGridModel subModel -> Html.map RequestGridMsg (Widget.RequestGrid.view subModel)
    ChecklistModel subModel -> Html.map ChecklistMsg (Widget.Checklist.view subModel)
    ChecklistGridModel subModel -> Html.map ChecklistGridMsg (Widget.ChecklistGrid.view subModel)
    ErrorModel err -> errorView err

errorView : String -> Html msg
errorView errorMsg =
    pre [] [ text "Widget Error: ", text errorMsg ]

main : Program D.Value Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

init : D.Value -> ( Model, Cmd Msg )
init flags =
  case D.decodeValue widgetDecoder flags of
    Ok widget -> ( widgetFlagToModel widget, widgetFlagToCmd widget )
    Err error -> ( ErrorModel (D.errorToString error), Cmd.none )

widgetFlagToCmd : Widget -> Cmd Msg
widgetFlagToCmd widget =
  case widget of
    LocationWidget _ -> Cmd.map LocationMsg Widget.Location.initialCmd
    LocationGridWidget -> Cmd.map LocationGridMsg Widget.LocationGrid.initialCmd
    RequestWidget _ -> Cmd.map RequestMsg Widget.Request.initialCmd
    RequestGridWidget -> Cmd.map RequestGridMsg Widget.RequestGrid.initialCmd
    ChecklistWidget _ -> Cmd.map ChecklistMsg Widget.Checklist.initialCmd
    ChecklistGridWidget -> Cmd.map ChecklistGridMsg Widget.ChecklistGrid.initialCmd

widgetFlagToModel : Widget -> Model
widgetFlagToModel widget =
  case widget of
    LocationWidget loc -> LocationModel loc
    LocationGridWidget -> LocationGridModel (Widget.LocationGrid.initialModel [])
    RequestWidget loc -> RequestModel loc
    RequestGridWidget -> RequestGridModel (Widget.RequestGrid.initialModel [])
    ChecklistWidget loc -> ChecklistModel loc
    ChecklistGridWidget -> ChecklistGridModel (Widget.ChecklistGrid.initialModel [])
