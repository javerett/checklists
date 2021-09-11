module Web.View.Locations.Show where
import Web.View.Prelude

data ShowView = ShowView { location :: Location }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={LocationsAction}>Locations</a></li>
                <li class="breadcrumb-item active">Show Location</li>
            </ol>
        </nav>
        <h1>Show Location</h1>
        {location}
    |]
