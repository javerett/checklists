module Web.View.Requests.New where
import Web.View.Prelude

data NewView = NewView { request :: Request }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={RequestsAction}>Requests</a></li>
                <li class="breadcrumb-item active">New Request</li>
            </ol>
        </nav>
        <h1>New Request</h1>
        {renderForm request}
    |]

renderForm :: Request -> Html
renderForm request = formFor request [hsx|
    {(textField #location)}
    {(textField #description)}
    {submitButton}
|]
