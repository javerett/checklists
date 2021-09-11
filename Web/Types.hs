module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data LocationsController
    = LocationsAction
    | NewLocationAction
    | ShowLocationAction { locationId :: !(Id Location) }
    | CreateLocationAction
    | EditLocationAction { locationId :: !(Id Location) }
    | UpdateLocationAction { locationId :: !(Id Location) }
    | DeleteLocationAction { locationId :: !(Id Location) }
    deriving (Eq, Show, Data)

data RequestsController
    = RequestsAction
    | NewRequestAction
    | ShowRequestAction { requestId :: !(Id Request) }
    | CreateRequestAction
    | EditRequestAction { requestId :: !(Id Request) }
    | UpdateRequestAction { requestId :: !(Id Request) }
    | DeleteRequestAction { requestId :: !(Id Request) }
    deriving (Eq, Show, Data)

data ChecklistsController
    = ChecklistsAction
    | NewChecklistAction
    | ShowChecklistAction { checklistId :: !(Id Checklist) }
    | CreateChecklistAction
    | EditChecklistAction { checklistId :: !(Id Checklist) }
    | UpdateChecklistAction { checklistId :: !(Id Checklist) }
    | DeleteChecklistAction { checklistId :: !(Id Checklist) }
    deriving (Eq, Show, Data)
