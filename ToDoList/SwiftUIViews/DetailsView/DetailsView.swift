import SwiftUI
import Foundation
import CocoaLumberjackSwift
import TaskCategory

struct DetailsView: View {
    @StateObject var model: ToDoItemModel
    @Binding var selectedItem: ToDoItem?
    
    @State var selectedText = ""
    @State var selectedImportance: ToDoItem.Importance = .normal
    @State var isDeadlineSelected = false
    @State var selectedDeadline: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State var selectedColor = Color(red: 0, green: 0, blue: 0)
    @State var selectedCategory = TaskCategory.defaultCategory()
    
    @Environment(\.dismiss) var dismiss
    var colorScheme: ColorScheme
    
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            
            DetailsHeaderView(
                model: model,
                selectedItem: $selectedItem,
                selectedText: $selectedText,
                selectedImportance: $selectedImportance,
                isDeadlineSelected: $isDeadlineSelected,
                selectedDeadline: $selectedDeadline,
                selectedColor: $selectedColor,
                selectedCategory: $selectedCategory,
                dismissParentView: dismiss
            )
            
            DetailsViewList(
                model: model,
                selectedItem: $selectedItem,
                selectedText: $selectedText,
                selectedImportance: $selectedImportance,
                isDeadlineSelected: $isDeadlineSelected,
                selectedDeadline: $selectedDeadline,
                selectedColor: $selectedColor,
                selectedCategory: $selectedCategory,
                parentDismiss: dismiss
            )
        }
        .environment(\.colorScheme, colorScheme)
        .padding()
        .background(colorScheme == .dark ? CustomColor.backDarkPrimary : CustomColor.backLightPrimary)
        .onAppear {
            if let selectedItem = selectedItem {
                selectedText = selectedItem.text
                selectedImportance = selectedItem.importance
                isDeadlineSelected = selectedItem.deadline != nil
                selectedDeadline = selectedItem.deadline ?? Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                selectedColor = selectedItem.color
                selectedCategory = selectedItem.category
            }
        }
        .onDisappear {
            onDismiss?()
        }
    }
}
