import SwiftUI
import CocoaLumberjackSwift
import TaskCategory

struct DetailsHeaderView: View {
    @StateObject var model: ToDoItemModel
    @Binding var selectedItem: ToDoItem?
    @Binding var selectedText: String
    @Binding var selectedImportance: ToDoItem.Importance
    @Binding var isDeadlineSelected: Bool
    @Binding var selectedDeadline: Date
    @Binding var selectedColor: Color
    @Binding var selectedCategory: TaskCategory
    
    var dismissParentView: DismissAction
    
    var body: some View {
        HStack {
            Button("Отменить") {
                DDLogVerbose("\(Date()): Отмена редактирования/создания задачи")
                dismissParentView()
            }
            Spacer()
            Text("Дело")
                .bold()
            Spacer()
            Button("Сохранить") {
                DDLogVerbose("\(Date()): Сохранение задачи")
                
                if let selectedItem = selectedItem {
                    model.updateToDoItem(
                        id: selectedItem.id,
                        newText: selectedText,
                        newImportance: selectedImportance,
                        newDeadline: isDeadlineSelected ? selectedDeadline : nil,
                        newIsDone: selectedItem.isDone,
                        newColor: selectedColor,
                        newCategory: selectedCategory
                    )
                } else {
                    model.addItem(
                        text: selectedText,
                        importance: selectedImportance,
                        deadline: isDeadlineSelected ? selectedDeadline : nil,
                        color: selectedColor,
                        category: selectedCategory
                    )
                }

                dismissParentView()
            }
            .bold()
            .disabled(selectedText.isEmpty)
        }
    }
}
