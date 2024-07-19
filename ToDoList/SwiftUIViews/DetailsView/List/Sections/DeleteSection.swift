import SwiftUI
import CocoaLumberjackSwift

struct DeleteSection: View {
    @StateObject var model: ToDoItemModel
    @Binding var selectedText: String
    @Binding var selectedItem: ToDoItem?
    
    var parentDismiss: DismissAction
    
    var body: some View {
        Section {
            Button("Удалить") {
                DDLogVerbose("\(Date()): Удалена задача \(selectedItem?.id ?? "")")
                if let selectedItem = selectedItem {
                    model.deleteItem(id: selectedItem.id)
                }
                parentDismiss()
            }
            .disabled(selectedText.isEmpty)
            .foregroundStyle(selectedText.isEmpty ? .gray : .red)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 56, maxHeight: 56)
        }
        .listRowInsets(EdgeInsets())
    }
}
