import SwiftUI

final class CustomColor {
    static let backLightiOSPrimary = Color(red: 0.95, green: 0.95, blue: 0.97, opacity: 1)
    static let backLightPrimary = Color(red: 0.97, green: 0.97, blue: 0.95, opacity: 1)
    static let backLightSecondary = Color(red: 1, green: 1, blue: 1, opacity: 1)
    static let backLightEvevated = Color(red: 1, green: 1, blue: 1, opacity: 1)
    static let labelLightTertiary = Color(red: 0, green: 0, blue: 0, opacity: 0.3)
    static let labelLightPrimary = Color(red: 0, green: 0, blue: 0, opacity: 1)
    static let supportLightSeparator = Color(red: 0, green: 0, blue: 0, opacity: 0.2)
    static let colorLightRed = Color(red: 1, green: 0.23, blue: 0.19, opacity: 1)
    static let colorLightGreen = Color(red: 0.2, green: 0.78, blue: 0.35, opacity: 1)
    static let colorLightBlue = Color(red: 0, green: 0.48, blue: 1, opacity: 1)
    static let colorLightGrayLight = Color(red: 0.82, green: 0.82, blue: 0.84, opacity: 1)
    
    static let backDarkiOSPrimary = Color(red: 0, green: 0, blue: 0, opacity: 1)
    static let backDarkPrimary = Color(red: 0.09, green: 0.09, blue: 0.09, opacity: 1)
    static let backDarkSecondary = Color(red: 0.14, green: 0.14, blue: 0.16, opacity: 1)
    static let backDarkEvevated = Color(red: 0.23, green: 0.23, blue: 0.25, opacity: 1)
    static let labelDarkTertiary = Color(red: 1, green: 1, blue: 1, opacity: 0.4)
    static let labelDarkPrimary = Color(red: 1, green: 1, blue: 1, opacity: 1)
    static let supportDarkSeparator = Color(red: 1, green: 1, blue: 1, opacity: 0.2)
    static let colorDarkRed = Color(red: 1, green: 0.27, blue: 0.23, opacity: 1)
    static let colorDarkGreen = Color(red: 0.2, green: 0.84, blue: 0.29, opacity: 1)
    static let colorDarkBlue = Color(red: 0.04, green: 0.52, blue: 1, opacity: 1)
    static let colorDarkGrayLight = Color(red: 0.28, green: 0.28, blue: 0.29, opacity: 1)
}


extension Color {
    var toHex: String {
        guard let components = cgColor?.components else { return "" }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let hex = String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))

        return hex
    }
}
