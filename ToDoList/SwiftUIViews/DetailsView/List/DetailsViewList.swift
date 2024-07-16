import SwiftUI
import TaskCategory

struct DetailsViewList: View {
    @StateObject var model: ToDoItemModel
    @Binding var selectedItem: ToDoItem?
    @Binding var selectedText: String
    @Binding var selectedImportance: ToDoItem.Importance
    @Binding var isDeadlineSelected: Bool
    @Binding var selectedDeadline: Date
    @Binding var selectedColor: Color
    @Binding var selectedCategory: TaskCategory
    
    var parentDismiss: DismissAction
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            TextEditorSection(selectedText: $selectedText, selectedColor: $selectedColor)
            OptionalAttributesSection(
                model: model,
                selectedItem: $selectedItem,
                selectedImportance: $selectedImportance,
                isDeadlineSelected: $isDeadlineSelected,
                selectedDeadline: $selectedDeadline,
                selectedColor: $selectedColor,
                selectedCategory: $selectedCategory
            )
            DeleteSection(model: model, selectedText: $selectedText, selectedItem: $selectedItem, parentDismiss: parentDismiss)
            
        }
        .background(colorScheme == .dark ? CustomColor.backDarkPrimary : CustomColor.backLightPrimary)
        .scrollContentBackground(.hidden)
    }
}
