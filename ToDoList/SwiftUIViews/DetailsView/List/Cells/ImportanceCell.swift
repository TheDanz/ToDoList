import SwiftUI

struct ImportanceCell: View {
    @Binding var selectedImportance: ToDoItem.Importance
    
    var body: some View {
        HStack {
            Text("Важность")
            Spacer()
            Picker("Importance", selection: $selectedImportance) {
                Image(systemName: "arrow.down").tag(ToDoItem.Importance.unimportant)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.gray)
                Text("нет").tag(ToDoItem.Importance.normal)
                Image(systemName: "exclamationmark.2").tag(ToDoItem.Importance.important)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.red)
                    .bold()
            }
            .frame(width: 150, height: 36)
            .pickerStyle(.segmented)
        }
    }
}
