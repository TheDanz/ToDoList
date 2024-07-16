import SwiftUI

struct ColorCell: View {
    @Binding var selectedColor: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
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
    }
}
