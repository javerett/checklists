module Web.View.Checklists.Show where
import Web.View.Prelude

data ShowView = ShowView { checklist :: Checklist }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ChecklistsAction}>Checklists</a></li>
                <li class="breadcrumb-item active">Show Checklist</li>
            </ol>
        </nav>
        <h1>Show Checklist</h1>
        <p>{checklist}</p>
    |]
