import SwiftUI

// MARK: - Break Trigger Source
enum BreakTrigger: String, Codable {
    case none
    case takeBreakButton
    case blockedAppShield
}

// MARK: - Break Service
@MainActor
@Observable
final class BreakService {
    static let shared = BreakService()
    
    private let screenTimeService = ScreenTimeService.shared
    private var timer: Timer?
    private var focusTrackingTimer: Timer?
    
    private(set) var isBreakActive: Bool = false
    private(set) var breakEndsAt: Date?
    private(set) var triggeredFrom: BreakTrigger = .none
    private(set) var remainingSeconds: Int = 0
    
    var isEarningBreak: Bool = false
    var lessonDidComplete: Bool = false
    
    private(set) var focusSessionStart: Date?
    private(set) var totalFocusHours: Double = 0
    
    let breakDurationMinutes: Int = 10
    
    func reset() {
        isBreakActive = false
        breakEndsAt = nil
        triggeredFrom = .none
        remainingSeconds = 0
        isEarningBreak = false
        lessonDidComplete = false
        focusSessionStart = nil
        totalFocusHours = 0
        timer?.invalidate()
        timer = nil
        focusTrackingTimer?.invalidate()
        focusTrackingTimer = nil
    }
    
    var isInScheduledHours: Bool {
        let startHour = UserDefaults.standard.integer(forKey: StorageKey.lockStartHour)
        let endHour = UserDefaults.standard.integer(forKey: StorageKey.lockEndHour)
        
        if startHour == endHour {
            let hasSetup = UserDefaults.standard.bool(forKey: StorageKey.hasCompletedOnboarding)
            return hasSetup // simplified for playground since we don't have selectedApps
        }
        
        // Simple hour check
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        
        if startHour < endHour {
            return hour >= startHour && hour < endHour
        } else {
            return hour >= startHour || hour < endHour
        }
    }
    
    var scheduleDescription: String {
        let startHour = UserDefaults.standard.integer(forKey: StorageKey.lockStartHour)
        let endHour = UserDefaults.standard.integer(forKey: StorageKey.lockEndHour)
        
        if startHour == endHour {
            return "24 hours"
        }
        return "\(formatHour(startHour)) - \(formatHour(endHour))"
    }
    
    private func formatHour(_ hour: Int) -> String {
        HourFormatter.format(hour, short: true)
    }
    
    private init() {
        loadState()
        loadFocusHours()
        checkBreakStatus()
        startFocusTracking()
    }
    
    private func loadFocusHours() {
        totalFocusHours = UserDefaults.standard.double(forKey: StorageKey.totalFocusHours)
        if let sessionStart = UserDefaults.standard.object(forKey: StorageKey.focusSessionStart) as? Date {
            let elapsed = Date().timeIntervalSince(sessionStart) / 3600
            totalFocusHours += elapsed
            saveFocusHours()
        }
    }
    
    private func saveFocusHours() {
        UserDefaults.standard.set(totalFocusHours, forKey: StorageKey.totalFocusHours)
        if let start = focusSessionStart {
            UserDefaults.standard.set(start, forKey: StorageKey.focusSessionStart)
        } else {
            UserDefaults.standard.removeObject(forKey: StorageKey.focusSessionStart)
        }
    }
    
    private func startFocusTracking() {
        focusTrackingTimer?.invalidate()
        
        if isInScheduledHours && !isBreakActive {
            focusSessionStart = Date()
            
            focusTrackingTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
                Task { @MainActor in
                    self?.updateFocusHours()
                }
            }
        }
    }
    
    private func updateFocusHours() {
        guard let start = focusSessionStart, isInScheduledHours, !isBreakActive else { return }
        let elapsed = Date().timeIntervalSince(start) / 3600
        totalFocusHours += elapsed
        focusSessionStart = Date()
        saveFocusHours()
    }
    
    // MARK: - Public API
    
    func startBreak(from trigger: BreakTrigger) {
        guard !isBreakActive else { return }
        
        isBreakActive = true
        isEarningBreak = false
        breakEndsAt = Date().addingTimeInterval(TimeInterval(breakDurationMinutes * 60))
        triggeredFrom = trigger
        remainingSeconds = breakDurationMinutes * 60
        
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            screenTimeService.removeBlocking()
        }
        
        saveState()
        startTimer()
        
        Haptics.shared.play(.heavy)
    }
    
    func endBreak() {
        guard isBreakActive else { return }
        
        isBreakActive = false
        breakEndsAt = nil
        triggeredFrom = .none
        remainingSeconds = 0
        isEarningBreak = false
        
        timer?.invalidate()
        timer = nil
        
        saveState()
        
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            if isInScheduledHours {
                screenTimeService.applyBlocking()
            }
        }
        
        Haptics.shared.play(.medium)
    }
    
    func beginEarningBreak() {
        isEarningBreak = true
    }
    
    func onLessonCompleted() {
        if isEarningBreak {
            isEarningBreak = false
            lessonDidComplete = true
        }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }
    
    private func tick() {
        guard let endTime = breakEndsAt else {
            endBreak()
            return
        }
        
        remainingSeconds = max(0, Int(endTime.timeIntervalSinceNow))
        
        if remainingSeconds <= 0 {
            endBreak()
        }
    }
    
    private func checkBreakStatus() {
        guard isBreakActive, let endTime = breakEndsAt else { return }
        
        if endTime > Date() {
            remainingSeconds = Int(endTime.timeIntervalSinceNow)
            startTimer()
        } else {
            endBreak()
        }
    }
    
    // MARK: - Persistence
    
    private func saveState() {
        UserDefaults.standard.set(isBreakActive, forKey: StorageKey.breakIsActive)
        UserDefaults.standard.set(breakEndsAt, forKey: StorageKey.breakEndsAt)
        UserDefaults.standard.set(triggeredFrom.rawValue, forKey: StorageKey.breakTriggeredFrom)
    }
    
    private func loadState() {
        isBreakActive = UserDefaults.standard.bool(forKey: StorageKey.breakIsActive)
        breakEndsAt = UserDefaults.standard.object(forKey: StorageKey.breakEndsAt) as? Date
        if let rawTrigger = UserDefaults.standard.string(forKey: StorageKey.breakTriggeredFrom) {
            triggeredFrom = BreakTrigger(rawValue: rawTrigger) ?? .none
        }
    }
    
    // MARK: - Helpers
    
    var formattedRemainingTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
