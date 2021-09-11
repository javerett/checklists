module Web.View.Locations.Index where
import Web.View.Prelude
import Web.JsonTypes ( locationToJSON )

data IndexView = IndexView { locations :: [Location] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Index <a href={pathTo NewLocationAction} class="btn btn-primary ml-4">+ New</a></h1>
        {locationGridWidget}
    |]

    json IndexView {..} = toJSON $ map locationToJSON locations

renderLocation location = [hsx|
    <tr>
        <td>{location}</td>
        <td><a href={ShowLocationAction (get #id location)}>Show</a></td>
        <td><a href={EditLocationAction (get #id location)} class="text-muted">Edit</a></td>
        <td><a href={DeleteLocationAction (get #id location)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
