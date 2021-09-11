module Web.View.Checklists.Edit where
import Web.View.Prelude

data EditView = EditView { checklist :: Checklist }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ChecklistsAction}>Checklists</a></li>
                <li class="breadcrumb-item active">Edit Checklist</li>
            </ol>
        </nav>
        <h1>Edit Checklist</h1>
        {renderForm checklist}
    |]

renderForm :: Checklist -> Html
renderForm checklist = formFor checklist [hsx|
    {(textField #request)}
    {(textField #name)}
    {submitButton}
|]
