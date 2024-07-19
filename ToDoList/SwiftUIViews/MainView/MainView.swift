import SwiftUI
import CocoaLumberjackSwift

struct MainView: View {
    @StateObject var model: ToDoItemModel = ToDoItemModel()
    @State var selectedItem: ToDoItem?
    @State var showDetailsView = false
    @State var showTaskCalendarVC = false
    @State var areDoneTasksShown = true
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            TaskList(
                model: model,
                selectedItem: $selectedItem,
                showDetailsView: $showDetailsView,
                showTaskCalendarVC: $showTaskCalendarVC,
                areDoneTasksShown: $areDoneTasksShown
            )
            .navigationTitle("Мои дела")
            .background(colorScheme == .dark ? CustomColor.backDarkiOSPrimary : CustomColor.backLightPrimary)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if model.isLoading {
                        ProgressView()
                    } else {
                        ProgressView().hidden()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    CalendarTransitionButton(showTaskCalendarVC: $showTaskCalendarVC)
                }
            }
            .overlay(alignment: .bottom) {
                PlusButton(showNewDetailsView: $showDetailsView)
            }
        }
        .sheet(isPresented: $showDetailsView) {
            DetailsView(model: model, selectedItem: $selectedItem, colorScheme: colorScheme)
        }
        .fullScreenCover(isPresented: $showTaskCalendarVC) {
            TaskCalendarVCRepresentable(model: model)
        }
        .sheet(item: $selectedItem) { _ in
            DetailsView(model: model, selectedItem: $selectedItem, colorScheme: colorScheme)
        }
    }
}

#Preview {
    MainView()
}
