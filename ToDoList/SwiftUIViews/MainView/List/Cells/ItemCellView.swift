import SwiftUI
import CocoaLumberjackSwift

struct ItemCellView: View {
    var currentItem: ToDoItem
    @StateObject var model: ToDoItemModel
    
    @Binding var showEditingDetailView: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: currentItem.isDone ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(currentItem.isDone ? (colorScheme == .dark ? CustomColor.colorDarkGreen : CustomColor.colorLightGreen) : (currentItem.importance == .important ? (colorScheme == .dark ? CustomColor.colorDarkRed : CustomColor.colorLightRed) : (colorScheme == .dark ? CustomColor.supportDarkSeparator : CustomColor.supportLightSeparator)))
                .onTapGesture {
                    DDLogVerbose("\(Date()): У задачи \(currentItem.id) изменено свойство isDone на \(!currentItem.isDone)")
                    model.updateToDoItem(id: currentItem.id, newIsDone: !currentItem.isDone, newColor: currentItem.color)
                }
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    
                    if currentItem.importance == ToDoItem.Importance.important {
                        Image(systemName: "exclamationmark.2")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.red)
                            .bold()
                    }
                    
                    if currentItem.importance == ToDoItem.Importance.unimportant {
                        Image(systemName: "arrow.down")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.gray)
                    }
                    
                    Text(currentItem.text)
                        .lineLimit(3)
                        .strikethrough(currentItem.isDone ? true : false)
                        .foregroundStyle(currentItem.isDone ? (colorScheme == .dark ? CustomColor.labelDarkTertiary : CustomColor.labelLightTertiary) : (colorScheme == .dark ? CustomColor.labelDarkPrimary : CustomColor.labelLightPrimary))
                }
                HStack {
                    if let deadline = currentItem.deadline {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(getDayAndMonth(from: deadline))
                    }
                }
                .foregroundStyle(colorScheme == .dark ? CustomColor.labelDarkTertiary : CustomColor.labelLightTertiary)
            }
            .padding(.horizontal, 16)
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 6.95, height: 11.9)
                .foregroundStyle(.gray)
            Rectangle()
                .offset(x: 20)
                .frame(width: 5)
                .foregroundColor(currentItem.color)
        }
    }
}
