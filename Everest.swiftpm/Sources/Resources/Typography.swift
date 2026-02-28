import SwiftUI

// MARK: - Typography System (Instrument Sans)
extension Font {
    /// Large display title (34pt Bold)
    static let displayLarge = Font.custom("InstrumentSans-Bold", size: 34)
    
    /// Section title (22pt Bold)
    static let titleLarge = Font.custom("InstrumentSans-Bold", size: 22)
    
    /// Card title (17pt Bold)
    static let titleMedium = Font.custom("InstrumentSans-Bold", size: 17)
    
    /// Body text (17pt Regular, 1.6x line spacing applied via modifier)
    static let bodyLarge = Font.custom("InstrumentSans-Regular", size: 17)
    
    /// Secondary body (15pt Regular)
    static let bodyMedium = Font.custom("InstrumentSans-Regular", size: 15)
    
    /// Caption (13pt Regular)
    static let caption = Font.custom("InstrumentSans-Regular", size: 13)
    
    /// Small caption (12pt Medium)
    static let captionSmall = Font.custom("InstrumentSans-Medium", size: 12)
    
    /// Large stat number (34pt Bold)
    static let statLarge = Font.custom("InstrumentSans-Bold", size: 34)
    
    /// Stat label (13pt Regular)
    static let statLabel = Font.custom("InstrumentSans-Regular", size: 13)
}

// MARK: - Text Style Modifiers
extension View {
    /// Premium body text with 1.6x line spacing
    func premiumBody() -> some View {
        self
            .font(.bodyLarge)
            .foregroundStyle(Color.appTextPrimary)
            .lineSpacing(17 * 0.6) // 1.6x line height
    }
    
    /// Secondary muted text
    func secondaryText() -> some View {
        self
            .font(.bodyMedium)
            .foregroundStyle(Color.appTextSecondary)
    }
}
