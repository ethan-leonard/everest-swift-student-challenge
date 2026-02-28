import SwiftUI

// MARK: - Everest Design System
extension Color {
    static let appBackground = Color.white
    static let appBrand = Color(hex: "4A7C59")
    static let appBrandLight = Color(hex: "4A7C59").opacity(0.15)
    static let appTextPrimary = Color(hex: "2D2D2D")
    static let appTextSecondary = Color(hex: "6B7280")
    static let appCardBackground = Color(hex: "F5F5F5")
    static let appGlacierDark = Color(hex: "1A365D")
    static let appGlacierLight = Color(hex: "E8F4F8")
}

// MARK: - Hex Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
