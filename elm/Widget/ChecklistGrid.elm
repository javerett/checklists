module Widget.ChecklistGrid exposing (..)

import Api.Generated exposing (ChecklistHeader)
import Api.Link exposing (getChecklistHeadersAction)
import Html exposing (..)
import Html.Attributes exposing (attribute, style, id)
import Html.Events exposing (onClick, onInput)
import Html.Styled.Attributes
import Http
import Dict exposing (Dict)

import Grid exposing (ColumnConfig, Msg(..), selectedAndVisibleItems, stringColumnConfig, linkColumnConfig)
import Grid.Item exposing (Item)

type alias Model =
  { gridModel : Grid.Model ChecklistHeader
  , clickedItem : Maybe (Item ChecklistHeader)
  , arePreferencesVisible : Bool
  }

type Msg
  = DisplayPreferences
  | HidePreferences
  | GridMsg (Grid.Msg ChecklistHeader)
  | LoadedChecklists (Result Http.Error (List ChecklistHeader))
  | NoOp

gridContainerId : String
gridContainerId = "grid-container"

columns : Dict String String -> List (ColumnConfig ChecklistHeader)
columns labels =
  [ requestColumn labels
  , nameColumn labels
  ]

requestColumn labels =
  linkColumnConfig
    { id = "Request"
    , editor = Nothing
    , getter = \x -> (x.request, "/ShowRequest")
    , localize = localize
    , setter = \x _ -> x
    , title = "Request"
    , tooltip = "Request"
    , width = 200
    }
    labels

nameColumn labels =
  stringColumnConfig
    { id = "Name"
    , editor = Nothing
    , getter = .name
    , localize = localize
    , setter = \x _ -> x
    , title = "Name"
    , tooltip = "Checklist name"
    , width = 200
    }
    labels

type alias Translations = Dict String String

translations : Translations
translations = Dict.fromList
  [
  ]

localize : String -> String
localize key = Maybe.withDefault key <| Dict.get key translations

rowClass : Item ChecklistHeader -> String
rowClass item =
  let
    even = toFloat item.visibleIndex / 2 == toFloat (item.visibleIndex // 2)
  in
    if item.selected then "selected-row"
    else if even then "even-row"
    else ""

gridConfig : Grid.Config ChecklistHeader
gridConfig =
  { canSelectRows = True
  , columns = columns Dict.empty
  , containerId = gridContainerId
  , footerHeight = 20
  , hasFilters = True
  , headerHeight = 60
  , labels = Dict.empty
  , lineHeight = 40
  , rowAttributes =
      \item ->
        [ Html.Styled.Attributes.class (rowClass item)
        , Html.Styled.Attributes.attribute "data-testid" "row"
        ]
  }

initialModel : List ChecklistHeader -> Model
initialModel locs = 
  let 
    ( gridModel, gridCmd ) = Grid.init gridConfig locs
  in
    { gridModel = gridModel
    , clickedItem = Nothing
    , arePreferencesVisible = False
    }

initialCmd : Cmd Msg
initialCmd = getChecklistHeadersAction LoadedChecklists

view : Model -> Html Msg
view model = div
  [ style "display" "flex"
  , style "flex-direction" "row"
  , style "align-items" "flex-start"
  ]
  [ viewMenu model
  , viewGrid model
  ]

viewMenu : Model -> Html Msg
viewMenu model = div
  [ style "display" "flex"
  , style "flex-direction" "column"
  , style "width" "200px"
  ]
  [ if model.arePreferencesVisible then
      viewButton "Hide Preferences" HidePreferences
    else
      viewButton "Show Preferences" DisplayPreferences
  , viewClickedItem model
  , viewSelectedItems model
  ]

viewGrid : Model -> Html Msg
viewGrid model = div
  [ id gridContainerId
  , style "background-color" "white"
  , style "margin-left" "auto"
  , style "margin-right" "auto"
  , style "color" "#555555"
  , style "width" "100%"
  ]
  [ Html.map GridMsg <| Grid.view model.gridModel
  ]


viewButton : String -> Msg -> Html Msg
viewButton label msg =
  button
    [ onClick msg
    , style "margin" "10px"
    , style "background-color" "darkturquoise"
    , style "padding" "0.5rem"
    , style "border-radius" "8px"
    , style "border-color" "aqua"
    , style "font-size" "medium"
    ]
    [ text label ]

viewClickedItem : Model -> Html Msg
viewClickedItem model =
    let
        selectedItem =
            case model.clickedItem of
                Just item ->
                    viewItem item

                Nothing ->
                    text "None."
    in
    div (menuItemAttributes "clickedItem") [ text "Clicked Item = ", selectedItem ]


viewSelectedItems : Model -> Html Msg
viewSelectedItems model =
    let
        selectedItems =
            selectedAndVisibleItems model.gridModel
    in
    div (menuItemAttributes "label")
        [ text <|
            if not <| List.isEmpty selectedItems then
                "SelectedItems:"

            else
                "Use checkboxes to select items."
        , ul (menuItemAttributes "selectedItems") <| List.map (\it -> li [] [ viewItem it ]) selectedItems
        ]

viewItem : Item ChecklistHeader -> Html msg
viewItem item =
    text ("ID: " ++ item.data.id)

menuItemAttributes : String -> List (Html.Attribute msg)
menuItemAttributes id =
    [ attribute "data-testid" id
    , style "padding-top" "10px"
    , style "color" "#EEEEEE"
    , style "margin" "10px"
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    DisplayPreferences ->
      let ( newGridModel, gridCmd ) = Grid.update Grid.ShowPreferences model.gridModel
      in ( { model | gridModel = newGridModel, arePreferencesVisible = True }, Cmd.map GridMsg gridCmd )
    HidePreferences ->
      let ( newGridModel, gridCmd ) = Grid.update Grid.UserClickedPreferenceCloseButton model.gridModel
      in ( { model | gridModel = newGridModel, arePreferencesVisible = False }, Cmd.map GridMsg gridCmd )
    GridMsg (UserClickedLine item) ->
      let ( newGridModel, gridCmd ) = Grid.update (UserClickedLine item) model.gridModel
      in ( { model | gridModel = newGridModel, clickedItem = Just item }, Cmd.map GridMsg gridCmd )
    GridMsg (UserToggledSelection item) ->
      let ( newGridModel, gridCmd ) = Grid.update (UserToggledSelection item) model.gridModel
      in ( { model | gridModel = newGridModel }, Cmd.map GridMsg gridCmd )
    GridMsg UserToggledAllItemSelection ->
      let ( newGridModel, gridCmd ) = Grid.update UserToggledAllItemSelection model.gridModel
      in ( { model | gridModel = newGridModel }, Cmd.map GridMsg gridCmd )
    GridMsg message ->
      let ( newGridModel, gridCmd ) = Grid.update message model.gridModel
      in ( { model | gridModel = newGridModel }, Cmd.map GridMsg gridCmd )
    LoadedChecklists result ->
      case result of
        Ok locs ->
          ( initialModel locs, Cmd.none )
        Err err ->
          ( model, Cmd.none )
    NoOp ->
      ( model, Cmd.none )
