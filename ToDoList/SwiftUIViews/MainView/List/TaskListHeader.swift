import SwiftUI
import CocoaLumberjackSwift

struct TaskListHeader: View {
    @StateObject var model: ToDoItemModel
    @Binding var areDoneTasksShown: Bool
    
    var body: some View {
        HStack {
            Text("Выполнено — \(model.toDoItems.filter { $0.isDone }.count)")
            Spacer()
            Menu {
                Section("Выполненные") {
                    Button(action: {
                        DDLogVerbose("\(Date()): Нажат переключатель Скрыть/Показать")
                        areDoneTasksShown.toggle()
                    }, label: {
                        Text(areDoneTasksShown ? "Скрыть" : "Показать")
                    })
                }
                Section("Сортировка") {
                    Button(action: {
                        DDLogVerbose("\(Date()): Включена сортировка по дате создания")
                        model.sort(by: .creationDate)
                    }, label: {
                        Text("По добавлению")
                    })
                    Button(action: {
                        DDLogVerbose("\(Date()): Включена сортировка по важности")
                        model.sort(by: .importance)
                    }, label: {
                        Text("По важности")
                    })
                }
            } label: {
                Text("Меню")
                    .fontWeight(.bold)
                    .font(.system(size: 15))
            }
        }
    }
}
