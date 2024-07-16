import SwiftUI

struct NewItemCellView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color(red: 0.82, green: 0.82, blue: 0.84))
                .hidden()
            VStack(alignment: .leading, spacing: 3) {
                Text("Новое")
                    .foregroundStyle(colorScheme == .dark ? CustomColor.labelDarkTertiary : CustomColor.labelLightTertiary)
            }
            .padding(.horizontal, 16)
        }
    }
}
