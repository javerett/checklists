module Web.View.Locations.New where
import Web.View.Prelude

data NewView = NewView { location :: Location }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={LocationsAction}>Locations</a></li>
                <li class="breadcrumb-item active">New Location</li>
            </ol>
        </nav>
        <h1>New Location</h1>
        {renderForm location}
    |]

renderForm :: Location -> Html
renderForm location = formFor location [hsx|
    {(textField #name)}
    {(textField #address)}
    {submitButton}
|]
