module Web.Controller.Locations where

import Web.Controller.Prelude
import Web.View.Locations.Index
import Web.View.Locations.New
import Web.View.Locations.Edit
import Web.View.Locations.Show

instance Controller LocationsController where
    action LocationsAction = autoRefresh do
        locations <- query @Location |> fetch
        render IndexView { .. }

    action NewLocationAction = do
        let location = newRecord
        render NewView { .. }

    action ShowLocationAction { locationId } = autoRefresh do
        location <- fetch locationId
        render ShowView { .. }

    action EditLocationAction { locationId } = do
        location <- fetch locationId
        render EditView { .. }

    action UpdateLocationAction { locationId } = do
        location <- fetch locationId
        location
            |> buildLocation
            |> ifValid \case
                Left location -> render EditView { .. }
                Right location -> do
                    location <- location |> updateRecord
                    setSuccessMessage "Location updated"
                    redirectTo EditLocationAction { .. }

    action CreateLocationAction = do
        let location = newRecord @Location
        location
            |> buildLocation
            |> ifValid \case
                Left location -> render NewView { .. } 
                Right location -> do
                    location <- location |> createRecord
                    setSuccessMessage "Location created"
                    redirectTo LocationsAction

    action DeleteLocationAction { locationId } = do
        location <- fetch locationId
        deleteRecord location
        setSuccessMessage "Location deleted"
        redirectTo LocationsAction

buildLocation location = location
    |> fill @["name","address"]
