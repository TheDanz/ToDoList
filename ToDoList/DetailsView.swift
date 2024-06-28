import SwiftUI
import Foundation

struct DetailsView: View {
    @ObservedObject var model: ToDoItemModel
    var isEditing = false
    var editingItemID: String?
    @State var inputText = ""
    @State var selectedImportance: ToDoItem.Importance = .normal
    @State var isDeadlineSelected = false
    @State var selectedDeadline: Date = (Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
    @State var selectedColor = Color(red: 0, green: 0, blue: 0)
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Отменить") {
                    dismiss()
                }
                Spacer()
                Text("Дело")
                    .bold()
                Spacer()
                Button("Сохранить") {
                    
                    if isEditing {
                        model.updateToDoItem(
                            id: editingItemID!,
                            newText: inputText,
                            newImportance: selectedImportance,
                            newDeadline: isDeadlineSelected ? selectedDeadline : nil,
                            newColor: selectedColor
                        )
                    } else {
                        model.addItem(
                            text: inputText,
                            importance: selectedImportance,
                            deadline: isDeadlineSelected ? selectedDeadline : nil
                        )
                    }

                    dismiss()
                }
                .bold()
                .disabled(inputText.isEmpty)
            }
            
            List {
                Section {
                        ZStack(alignment: .topLeading) {

                            TextEditor(text: $inputText)
                                .padding(4)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                            Rectangle()
                                .offset(x: -9)
                                .frame(width: 5)
                                .foregroundColor(selectedColor)

                            
                            if inputText.isEmpty {
                                Text("Что надо сделать?")
                                    .foregroundColor(colorScheme == .dark ? CustomColor.labelDarkTertiary : CustomColor.labelLightTertiary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                                    .allowsHitTesting(false)
                            }
                        }
                        .frame(minHeight: 120)
                        .padding(-10)
                }
                
                Section {
                    
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
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Цвет")
                            Text(selectedColor.toHex)
                                .foregroundStyle(colorScheme == .dark ? CustomColor.colorDarkBlue : CustomColor.colorLightBlue)
                                .font(.system(size: 15))
                                .bold()
                        }
                        ColorPicker("", selection: $selectedColor)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Сделать до")
                            if isDeadlineSelected {
                                Text(getDayMonthAndYear(from: selectedDeadline))
                                    .foregroundStyle(colorScheme == .dark ? CustomColor.colorDarkBlue : CustomColor.colorLightBlue)
                                    .font(.system(size: 15))
                                    .bold()
    
                            }
                        }
                        Toggle(isOn: $isDeadlineSelected, label: {})
                    }
                    
                    if isDeadlineSelected {
                        DatePicker("", selection: $selectedDeadline, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                    }
                }
                
                Section {
                    Button("Удалить") {
                        
                        if isEditing {
                            model.deleteItem(id: editingItemID ?? "")
                        }
                        dismiss()
                    }
                    .disabled(inputText.isEmpty)
                    .foregroundStyle(inputText.isEmpty ? .gray : .red)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 56, maxHeight: 56)
                }
                .listRowInsets(EdgeInsets())
                
            }
            .background(colorScheme == .dark ? CustomColor.backDarkPrimary : CustomColor.backLightPrimary)
            .scrollContentBackground(.hidden)
        }
        .padding()
        .background(colorScheme == .dark ? CustomColor.backDarkPrimary : CustomColor.backLightPrimary)
    }
}
