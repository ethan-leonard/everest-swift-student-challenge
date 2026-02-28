import Foundation

@MainActor
@Observable
final class AuthenticationService {
    static let shared = AuthenticationService()
    
    var isAuthenticated = true
    var isLoading = false
    
    private init() {}
    
    func configure() {
        // Automatically authenticated in playground
        isAuthenticated = true
        isLoading = false
    }
    
    func signInAnonymously() async throws {
        // Assume success instantly
        self.isAuthenticated = true
    }
    
    func signOut() throws {
        self.isAuthenticated = false
    }
}
