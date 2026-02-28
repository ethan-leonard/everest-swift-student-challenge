import SwiftUI

/// Minimal SettingsView stub for the playground demo.
/// The production app has a full settings screen with Firebase Auth, 
/// FamilyControls, and profile editing — none of which apply here.
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "gearshape.2.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.appTextSecondary.opacity(0.3))
            
            Text("Settings")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)
            
            Text("Settings are not available\nin the Playground demo.")
                .font(.system(size: 16))
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.appBackground)
        .navigationTitle("Settings")
    }
}
