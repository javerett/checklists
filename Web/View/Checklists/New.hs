module Web.View.Checklists.New where
import Web.View.Prelude

data NewView = NewView { checklist :: Checklist }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ChecklistsAction}>Checklists</a></li>
                <li class="breadcrumb-item active">New Checklist</li>
            </ol>
        </nav>
        <h1>New Checklist</h1>
        {renderForm checklist}
    |]

renderForm :: Checklist -> Html
renderForm checklist = formFor checklist [hsx|
    {(textField #request)}
    {(textField #name)}
    {submitButton}
|]
