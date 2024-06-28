import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var model: ToDoItemModel = ToDoItemModel()
    @State private var showNewDetailsView = false
    @State private var showDatePicker = false
    @State private var showEditingDetailView = false
    @State private var selectedDateToChange = Date()
    @State private var selectedItem: ToDoItem?
    @State private var areDoneTasksShown = true
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(model.toDoItems, id: \.id) { currentItem in
                        if areDoneTasksShown || (!areDoneTasksShown && !currentItem.isDone) {
                            HStack {
                                Image(systemName: currentItem.isDone ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(currentItem.isDone ? (colorScheme == .dark ? CustomColor.colorDarkGreen : CustomColor.colorLightGreen) : (currentItem.importance == .important ? (colorScheme == .dark ? CustomColor.colorDarkRed : CustomColor.colorLightRed) : (colorScheme == .dark ? CustomColor.supportDarkSeparator : CustomColor.supportLightSeparator)))
                                    .onTapGesture {
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
                                    .onTapGesture {
                                        selectedItem = currentItem
                                        showDatePicker = true
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
                            .swipeActions(edge: .leading) {
                                Button {
                                    model.updateToDoItem(id: currentItem.id, newIsDone: !currentItem.isDone, newColor: currentItem.color)
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    model.deleteItem(id: currentItem.id)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(colorScheme == .dark ? CustomColor.colorDarkRed : CustomColor.colorLightRed)
                                
                                Button {
                                    selectedItem = currentItem
                                    showEditingDetailView = true
                                } label: {
                                    Image(systemName: "info.circle")
                                }
                                .tint(CustomColor.colorLightGrayLight)
                            }
                            
                        }
                    }
                    
                    HStack {
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(red: 0.82, green: 0.82, blue: 0.84))
                            .hidden()
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Новое")
                                .foregroundStyle(colorScheme == .dark ? CustomColor.labelDarkTertiary : CustomColor.labelLightTertiary)
                                .onTapGesture {
                                    showNewDetailsView = true
                                }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                } header: {
                    HStack {
                        Text("Выполнено — \(model.toDoItems.filter { $0.isDone }.count)")
                        Spacer()
                        Menu {
                            Section {
                                Button(action: {
                                    areDoneTasksShown.toggle()
                                })  {
                                    Text(areDoneTasksShown ? "Скрыть сделанные" : "Показать сделанные")
                                }
                            }
                            Section {
                                Button(action: {
                                    model.sort(by: .creationDate)
                                })  {
                                    Text("По добавлению")
                                }
                                Button(action: {
                                    model.sort(by: .importance)
                                })  {
                                    Text("По важности")
                                }
                            }
                        } label: {
                            Text("Меню")
                                .fontWeight(.bold)
                                .font(.system(size: 15))
                        }
                    }
                }
            }
            .navigationTitle("Мои дела")
            .background(colorScheme == .dark ? CustomColor.backDarkiOSPrimary : CustomColor.backLightPrimary)
            .scrollContentBackground(.hidden)
            .overlay(alignment: .bottom) {
                Button {
                    showNewDetailsView = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                  }
            }
        }
        .sheet(isPresented: $showNewDetailsView) {
            DetailsView(model: model)
        }
        .sheet(isPresented: $showEditingDetailView) {
            DetailsView(
                model: model,
                isEditing: true,
                editingItemID: selectedItem?.id,
                inputText: selectedItem?.text ?? "",
                selectedImportance: selectedItem?.importance ?? .normal,
                isDeadlineSelected: selectedItem?.deadline != nil ? true : false,
                selectedDeadline: selectedItem?.deadline ?? Date(),
                selectedColor: selectedItem?.color ?? .white
            )
        }
        .fullScreenCover(isPresented: $showDatePicker) {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDateToChange,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Button("Готово") {
                    model.updateToDoItem(
                        id: selectedItem?.id ?? "",
                        newText: selectedItem?.text,
                        newImportance: selectedItem?.importance,
                        newDeadline: selectedDateToChange,
                        newIsDone: selectedItem?.isDone,
                        newColor: selectedItem?.color ?? .white
                    )
                    selectedItem = ToDoItem(text: "")
                    showDatePicker = false
                }
                .bold()
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(15)
            .padding()
            .background(colorScheme == .dark ? CustomColor.backDarkPrimary : CustomColor.backLightPrimary)
        }
    }
}

#Preview {
    MainView()
}
