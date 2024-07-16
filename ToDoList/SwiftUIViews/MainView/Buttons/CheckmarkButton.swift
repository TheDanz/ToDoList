import SwiftUI
import CocoaLumberjackSwift

struct CheckmarkButton: View {
    @StateObject var model: ToDoItemModel
    var currentItem: ToDoItem
    
    var body: some View {
        Button {
            DDLogVerbose("\(Date()): У задачи \(currentItem.id) изменено свойство isDone на \(!currentItem.isDone)")
            model.updateToDoItem(id: currentItem.id, newIsDone: !currentItem.isDone, newColor: currentItem.color)
        } label: {
            Image(systemName: "checkmark.circle.fill")
        }
        .tint(.green)
    }
}
