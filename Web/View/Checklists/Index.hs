module Web.View.Checklists.Index where
import Web.View.Prelude
import Web.JsonTypes ( checklistHeaderToJSON )

data IndexView = IndexView { checklists :: [(Checklist, [ChecklistItem])] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={ChecklistsAction}>Checklists</a></li>
            </ol>
        </nav>
        <h1>Index <a href={pathTo NewChecklistAction} class="btn btn-primary ml-4">+ New</a></h1>
        {checklistGridWidget}
    |]

    json IndexView {..} = toJSON $ map (checklistHeaderToJSON . fst) checklists
