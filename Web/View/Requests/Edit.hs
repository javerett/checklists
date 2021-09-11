module Web.View.Requests.Edit where
import Web.View.Prelude

data EditView = EditView { request :: Request }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={RequestsAction}>Requests</a></li>
                <li class="breadcrumb-item active">Edit Request</li>
            </ol>
        </nav>
        <h1>Edit Request</h1>
        {renderForm request}
    |]

renderForm :: Request -> Html
renderForm request = formFor request [hsx|
    {(textField #location)}
    {(textField #description)}
    {submitButton}
|]
