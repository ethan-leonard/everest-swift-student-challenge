import SwiftUI

@MainActor
@Observable
final class ScreenTimeService {
    static let shared = ScreenTimeService()
    
    private(set) var isAuthorized = true
    private(set) var isBlockingActive = false
    
    private init() {}
    
    func checkAuthorizationStatus() {
        isAuthorized = true
    }
    
    func requestAuthorization() async throws {
        isAuthorized = true
    }
    
    func applyBlocking() {
        guard isAuthorized else { return }
        isBlockingActive = true
    }
    
    func removeBlocking() {
        isBlockingActive = false
    }
}
