import SwiftUI

struct JourneyHeader: View {
    let course: Course
    let completed: Int
    let total: Int
    let streakDays: [Bool]
    var actualStreak: Int = 0
    var onTakeBreak: (() -> Void)?
    
    var elevation: Int {
        let progress = min(Double(completed) / Double(total), 1.0)
        return Int(Double(course.altitude) * progress)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Text("\(completed)/\(total) Lessons • \(elevation)m")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.appTextSecondary)
                }
                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.appTextSecondary)
                        .frame(width: 44, height: 44)
                        .glassCircleStyle()
                }
            }
            
            WeeklyStreakBar(streakDays: streakDays, actualStreak: actualStreak)
            
            // Focus pill removed - now using FocusStatusBar above nav bar
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}

