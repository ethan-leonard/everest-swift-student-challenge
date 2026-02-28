@preconcurrency import CoreMotion
import SwiftUI

@MainActor
@Observable
final class MotionManager {
    private let motionManager = CMMotionManager()
    
    var pitch: Double = 0.0
    var roll: Double = 0.0
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
    }
    
    func start() {
        guard motionManager.isDeviceMotionAvailable, !motionManager.isDeviceMotionActive else { return }
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion else { return }
            Task { @MainActor in
                withAnimation(.linear(duration: 0.1)) {
                    self?.pitch = motion.attitude.pitch
                    self?.roll = motion.attitude.roll
                }
            }
        }
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
