import SwiftUI
import CocoaLumberjackSwift

struct CalendarTransitionButton: View {
    @Binding var showTaskCalendarVC: Bool
    
    var body: some View {
        Button {
            DDLogVerbose("\(Date()): Переход на экран с календарем")
            showTaskCalendarVC = true
        } label: {
            Image(systemName: "calendar")
        }
    }
}
