module Web.Controller.Checklists where

import Web.Controller.Prelude
import Web.View.Checklists.Index
import Web.View.Checklists.New
import Web.View.Checklists.Edit
import Web.View.Checklists.Show

getChecklistItems :: (?modelContext :: ModelContext) => Checklist -> IO [ChecklistItem]
getChecklistItems checklist = query @ChecklistItem |> filterWhere (#checklist, get #id checklist) |> fetch

instance Controller ChecklistsController where
    action ChecklistsAction = autoRefresh do
        heads <- query @Checklist |> fetch
        checklists <- sequence $ map (\x -> do
            items <- getChecklistItems x
            return (x, items)
            ) heads
        render IndexView { .. }

    action NewChecklistAction = do
        let checklist = newRecord
        render NewView { .. }

    action ShowChecklistAction { checklistId } = autoRefresh do
        checklist <- fetch checklistId
        render ShowView { .. }

    action EditChecklistAction { checklistId } = do
        checklist <- fetch checklistId
        render EditView { .. }

    action UpdateChecklistAction { checklistId } = do
        checklist <- fetch checklistId
        checklist
            |> buildChecklist
            |> ifValid \case
                Left checklist -> render EditView { .. }
                Right checklist -> do
                    checklist <- checklist |> updateRecord
                    setSuccessMessage "Checklist updated"
                    redirectTo EditChecklistAction { .. }

    action CreateChecklistAction = do
        let checklist = newRecord @Checklist
        checklist
            |> buildChecklist
            |> ifValid \case
                Left checklist -> render NewView { .. } 
                Right checklist -> do
                    checklist <- checklist |> createRecord
                    setSuccessMessage "Checklist created"
                    redirectTo ChecklistsAction

    action DeleteChecklistAction { checklistId } = do
        checklist <- fetch checklistId
        deleteRecord checklist
        setSuccessMessage "Checklist deleted"
        redirectTo ChecklistsAction

buildChecklist checklist = checklist
    |> fill @["request","name"]
