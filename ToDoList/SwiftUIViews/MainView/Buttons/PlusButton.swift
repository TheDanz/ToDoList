import SwiftUI
import CocoaLumberjackSwift

struct PlusButton: View {
    @Binding var showNewDetailsView: Bool
    
    var body: some View {
        Button {
            DDLogVerbose("\(Date()): Создание новой задачи по кнопке плюс")
            showNewDetailsView = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .foregroundStyle(Color(red: 0, green: 0.48, blue: 1))
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}
