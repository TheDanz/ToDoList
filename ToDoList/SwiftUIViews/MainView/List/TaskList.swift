import SwiftUI
import CocoaLumberjackSwift

struct TaskList: View {
    @StateObject var model: ToDoItemModel
    @Binding var selectedItem: ToDoItem?
    @Binding var showDetailsView: Bool
    @Binding var showTaskCalendarVC: Bool
    @Binding var areDoneTasksShown: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section {
                ForEach(model.toDoItems, id: \.id) { currentItem in
                    if areDoneTasksShown || (!areDoneTasksShown && !currentItem.isDone) {
                        ItemCellView(currentItem: currentItem, model: model, showEditingDetailView: $showDetailsView)
                            .swipeActions(edge: .leading) {
                                CheckmarkButton(model: model, currentItem: currentItem)
                            }
                            .swipeActions(edge: .trailing) {
                                TrashButton(model: model, currentItem: currentItem)
                                InfoButton(model: model, selectedItem: $selectedItem, currentItem: currentItem)
                            }
                    }
                }
                NewItemCellView()
                    .onTapGesture {
                        DDLogVerbose("\(Date()): Нажата кнопка создания новой задачи внизу списка")
                        showDetailsView = true
                    }
            } header: {
                TaskListHeader(model: model, areDoneTasksShown: $areDoneTasksShown)
            }
        }
    }
}
