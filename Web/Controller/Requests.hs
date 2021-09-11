module Web.Controller.Requests where

import Web.Controller.Prelude
import Web.View.Requests.Index
import Web.View.Requests.New
import Web.View.Requests.Edit
import Web.View.Requests.Show

import Web.JsonTypes

-- TODO: Update to V11 of the IHP library so we can join tables!
instance Controller RequestsController where
    action RequestsAction = autoRefresh do
        heads <- query @Request |> fetch
        requests <- sequence $ map (\x -> do
            loc <- fetch $ get #location x
            return $ DecoratedRequest x (get #name loc)
            ) heads
        render IndexView { .. }

    action NewRequestAction = do
        let request = newRecord
        render NewView { .. }

    action ShowRequestAction { requestId } = autoRefresh do
        request <- fetch requestId
        render ShowView { .. }

    action EditRequestAction { requestId } = do
        request <- fetch requestId
        render EditView { .. }

    action UpdateRequestAction { requestId } = do
        request <- fetch requestId
        request
            |> buildRequest
            |> ifValid \case
                Left request -> render EditView { .. }
                Right request -> do
                    request <- request |> updateRecord
                    setSuccessMessage "Request updated"
                    redirectTo EditRequestAction { .. }

    action CreateRequestAction = do
        let request = newRecord @Request
        request
            |> buildRequest
            |> ifValid \case
                Left request -> render NewView { .. } 
                Right request -> do
                    request <- request |> createRecord
                    setSuccessMessage "Request created"
                    redirectTo RequestsAction

    action DeleteRequestAction { requestId } = do
        request <- fetch requestId
        deleteRecord request
        setSuccessMessage "Request deleted"
        redirectTo RequestsAction

buildRequest request = request
    |> fill @["location","description"]
