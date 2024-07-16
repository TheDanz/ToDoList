import SwiftUI

struct TextEditorSection: View {
    @Binding var selectedText: String
    @Binding var selectedColor: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        Section {
                ZStack(alignment: .topLeading) {

                    TextEditor(text: $selectedText)
                        .padding(4)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Rectangle()
                        .offset(x: -9)
                        .frame(width: 5)
                        .foregroundColor(selectedColor)
                    
                    if selectedText.isEmpty {
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
    }
}
