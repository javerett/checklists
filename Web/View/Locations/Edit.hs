module Web.View.Locations.Edit where
import Web.View.Prelude

data EditView = EditView { location :: Location }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={LocationsAction}>Locations</a></li>
                <li class="breadcrumb-item active">Edit Location</li>
            </ol>
        </nav>
        <h1>Edit Location</h1>
        {renderForm location}
    |]

renderForm :: Location -> Html
renderForm location = formFor location [hsx|
    {(textField #name)}
    {(textField #address)}
    {submitButton}
|]
