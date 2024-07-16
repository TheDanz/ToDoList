import SwiftUI
import CocoaLumberjackSwift

struct TrashButton: View {
    @StateObject var model: ToDoItemModel
    var currentItem: ToDoItem
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            DDLogVerbose("\(Date()): Задача \(currentItem.id) удалена")
            model.deleteItem(id: currentItem.id)
        } label: {
            Image(systemName: "trash")
        }
        .tint(colorScheme == .dark ? CustomColor.colorDarkRed : CustomColor.colorLightRed)
    }
}
