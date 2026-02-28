import SwiftUI

struct XPBadge: View {
    let xp: Int
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 16, weight: .bold))
            
            Text("+\(xp) XP")
                .font(.system(size: 16, weight: .bold))
        }
        .foregroundStyle(Color.appTextPrimary)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
        .scaleEffect(animate ? 1.1 : 1)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).repeatCount(2, autoreverses: true)) {
                animate = true
            }
        }
    }
}
