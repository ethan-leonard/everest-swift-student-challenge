# Everest - Swift Student Challenge 2026

Everest is an app designed to help you climb out of the digital dopamine loop through a combination of habit-changing lessons and time-management strategies.

This Swift Playground demonstrates the core Everest experience, designed to run entirely offline in a 3-minute flow.

### Setup Instructions
1. Open up `Everest.swiftpm` in Xcode on your Mac.
2. Ensure the destination is set to an iOS Simulator (e.g., iPhone 15 or 16).
3. Build and Run the playground (Cmd + R).

### Features Demonstrated
- **Interactive Lessons**: A simulated learning engine designed to replace doom-scrolling with productive, psychological learning.
- **Screen Time Reclaiming**: An onboarded calculation of how many hours you lose to distractions, and a structured plan to win them back.
- **Mock Focus Blocker**: A demonstration of the app's Screen Time blocking mechanism, using a simulated data set to bypass Xcode Playgrounds limitations with the actual DeviceActivity API.
- **Journey Summit**: A gamified learning path tracking your progress as you ascend the mountain of self-control.

### Limitations in the Playground
To comply with the Swift Student Challenge constraints:
- **No Third-Party APIs**: Firebase Authentication and Firestore have been completely removed. Data is stored locally via `UserDefaults`.
- **Offline Assets**: All courses, images, and progression logic are bundled locally and fully functional without an internet connection.
- **Simulated Screen Time**: Due to Sandbox restrictions in Swift Playgrounds/Simulators, Apple's `FamilyControls` and `ManagedSettings` frameworks cannot run. The screen time blocking behavior is instead simulated natively in the UI to give you an understanding of how the real mechanism works.
