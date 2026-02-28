import SwiftUI

struct AnswerOptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let showResult: Bool
    let action: () -> Void
    
    private var backgroundColor: Color {
        guard showResult else {
            return isSelected ? Color.appBrandLight : Color.appCardBackground
        }
        if isSelected {
            return isCorrect ? Color.appBrand : Color(hex: "E07A5F")
        }
        if isCorrect {
            return Color.appBrand.opacity(0.3)
        }
        return Color.appCardBackground
    }
    
    private var textColor: Color {
        guard showResult && isSelected else {
            return Color.appTextPrimary
        }
        return .white
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if showResult && isSelected {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .disabled(showResult)
    }
}
