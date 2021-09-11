module Widget.LocationGrid exposing (..)

import Api.Generated exposing (Location)
import Api.Link exposing (getLocationsAction)
import Html exposing (..)
import Html.Attributes exposing (attribute, style, id)
import Html.Events exposing (onClick, onInput)
import Html.Styled.Attributes
import Http
import Dict exposing (Dict)

import Grid exposing (ColumnConfig, Msg(..), selectedAndVisibleItems, stringColumnConfig)
import Grid.Item exposing (Item)

type alias Model =
  { gridModel : Grid.Model Location
  , clickedItem : Maybe (Item Location)
  , arePreferencesVisible : Bool
  }

type Msg
  = DisplayPreferences
  | HidePreferences
  | SetFilters
  | ResetFilters
  | SetAscendingOrder
  | SetDecendingOrder
  | UserRequiredScrollingToLocation String
  | GridMsg (Grid.Msg Location)
  | LoadedLocations (Result Http.Error (List Location))
  | NoOp

gridContainerId : String
gridContainerId = "grid-container"

columns : Dict String String -> List (ColumnConfig Location)
columns labels =
  [ nameColumn labels
  , addressColumn labels
  ]

nameColumn labels =
  stringColumnConfig
    { id = "Name"
    , editor = Just { fromString = setName, maxLength = 20 }
    , getter = .name
    , localize = localize
    , setter = setName
    , title = "Name"
    , tooltip = "Project name"
    , width = 200
    }
    labels

addressColumn labels =
  stringColumnConfig
    { id = "Address"
    , editor = Nothing
    , getter = .address
    , localize = localize
    , setter = \item _ -> item
    , title = "Address"
    , tooltip = "Location address"
    , width = 400
    }
    labels

setName : Item Location -> String -> Item Location
setName item name =
  let
    oldData = item.data
    newData = { oldData | name = name }
  in { item | data = newData }

type alias Translations = Dict String String

translations : Translations
translations = Dict.fromList
  [
  ]

localize : String -> String
localize key = Maybe.withDefault key <| Dict.get key translations

rowClass : Item Location -> String
rowClass item =
  let
    even = toFloat item.visibleIndex / 2 == toFloat (item.visibleIndex // 2)
  in
    if item.selected then "selected-row"
    else if even then "even-row"
    else ""

gridConfig : Grid.Config Location
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

initialModel : List Location -> Model
initialModel locs = 
  let 
    ( gridModel, gridCmd ) = Grid.init gridConfig locs
  in
    { gridModel = gridModel
    , clickedItem = Nothing
    , arePreferencesVisible = False
    }

initialCmd : Cmd Msg
initialCmd = getLocationsAction LoadedLocations

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

viewInput : Html Msg
viewInput =
  label (menuItemAttributes "input-label")
    [ text "Scroll to first location starting with:"
    , input (menuItemAttributes "input"
        ++ [ onInput UserRequiredScrollingToLocation
           , style "color" "black"
           , style "vertical-align" "baseline"
           , style "font-size" "medium"
           ])
           []
    ]

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

viewItem : Item Location -> Html msg
viewItem item =
    text ("id:" ++ item.data.id ++ " - name: " ++ item.data.name ++ "")

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
    SetFilters ->
      let
        filters = Dict.fromList [ ( "Name", "o" ) ]
        message = Grid.SetFilters filters
        ( newGridModel, gridCmd ) = Grid.update message model.gridModel
      in
        ( { model | gridModel = newGridModel }, Cmd.map GridMsg gridCmd )
    ResetFilters ->
      let
        message = Grid.SetFilters Dict.empty
        ( newGridModel, gridCmd ) = Grid.update message model.gridModel
      in ( { model | gridModel = newGridModel }, Cmd.map GridMsg gridCmd )
    SetAscendingOrder ->
      let
        message = Grid.SetSorting "Name" Grid.Ascending
        ( newGridModel, gridCmd ) = Grid.update message model.gridModel
      in ( { model | gridModel = newGridModel }, Cmd.map GridMsg gridCmd )
    SetDecendingOrder ->
      let
        message = Grid.SetSorting "Name" Grid.Descending
        ( newGridModel, gridCmd ) = Grid.update message model.gridModel
      in ( { model | gridModel = newGridModel }, Cmd.map GridMsg gridCmd )
    UserRequiredScrollingToLocation name ->
      let
        message = Grid.ScrollTo (\item -> String.startsWith (String.toLower name) (String.toLower item.data.name))
        ( newGridModel, gridCmd ) = Grid.update message model.gridModel
      in ( { model | gridModel = newGridModel }, Cmd.map GridMsg gridCmd )
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
    LoadedLocations result ->
      case result of
        Ok locs ->
          ( initialModel locs, Cmd.none )
        Err err ->
          ( model, Cmd.none )
    NoOp ->
      ( model, Cmd.none )
