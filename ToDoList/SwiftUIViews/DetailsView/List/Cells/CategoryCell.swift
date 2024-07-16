import SwiftUI
import TaskCategory
import CocoaLumberjackSwift

struct CategoryCell: View {
    @StateObject var model: ToDoItemModel
    @Binding var selectedItem: ToDoItem?
    @Binding var selectedCategory: TaskCategory
    
    var body: some View {
        HStack {
            Menu {
                ForEach(model.categories, id: \.name) { category in
                    Button {
                        DDLogVerbose("\(Date()): Для задачи \(selectedItem?.id) выбрана категория \(category.name)")
                        selectedCategory = TaskCategory(name: category.name, color: category.color)
                    } label: {
                        Text(category.name)
                    }
                }
            } label: {
                Text("Выбрать категорию")
            }
            Spacer()
            Circle()
                .fill(Color(selectedCategory.color))
                .frame(width: 10, height: 10)
                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 3)
        }
    }
}
