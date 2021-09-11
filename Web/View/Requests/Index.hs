module Web.View.Requests.Index where
import Web.View.Prelude
import Web.JsonTypes ( DecoratedRequest, requestToJSON )

data IndexView = IndexView { requests :: [DecoratedRequest] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Index <a href={pathTo NewRequestAction} class="btn btn-primary ml-4">+ New</a></h1>
        {requestGridWidget}
    |]

    json IndexView {..} = toJSON $ map requestToJSON requests

renderRequest request = [hsx|
    <tr>
        <td>{request}</td>
        <td><a href={ShowRequestAction (get #id request)}>Show</a></td>
        <td><a href={EditRequestAction (get #id request)} class="text-muted">Edit</a></td>
        <td><a href={DeleteRequestAction (get #id request)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
