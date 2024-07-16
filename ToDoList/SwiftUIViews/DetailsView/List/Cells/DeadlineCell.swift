import SwiftUI

struct DeadlineCell: View {
    @Binding var isDeadlineSelected: Bool
    @Binding var selectedDeadline: Date
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
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
    }
}
