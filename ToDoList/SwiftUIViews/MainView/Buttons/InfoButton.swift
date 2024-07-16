import SwiftUI
import CocoaLumberjackSwift

struct InfoButton: View {
    @StateObject var model: ToDoItemModel
    @Binding var selectedItem: ToDoItem?
    var currentItem: ToDoItem
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            selectedItem = currentItem
            DDLogVerbose("\(Date()): Начало редактирования задачи \(selectedItem!.id)")
        } label: {
            Image(systemName: "info.circle")
        }
        .tint(CustomColor.colorLightGrayLight)
    }
}
