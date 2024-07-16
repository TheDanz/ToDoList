import SwiftUI
import TaskCategory

struct OptionalAttributesSection: View {
    @StateObject var model: ToDoItemModel
    @Binding var selectedItem: ToDoItem?
    @Binding var selectedImportance: ToDoItem.Importance
    @Binding var isDeadlineSelected: Bool
    @Binding var selectedDeadline: Date
    @Binding var selectedColor: Color
    @Binding var selectedCategory: TaskCategory
    
    var body: some View {
        Section {
            
            ImportanceCell(selectedImportance: $selectedImportance)
            ColorCell(selectedColor: $selectedColor)
            CategoryCell(model: model, selectedItem: $selectedItem, selectedCategory: $selectedCategory)
            DeadlineCell(isDeadlineSelected: $isDeadlineSelected, selectedDeadline: $selectedDeadline)
            
            if isDeadlineSelected {
                DatePicker("", selection: $selectedDeadline, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
            }
        }
    }
}
