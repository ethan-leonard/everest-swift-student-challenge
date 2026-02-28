# Playground Conversion Plan

**Goal:** Modify the Everest App into a standalone Swift Playground (.swiftpm) for the 2026 Swift Student Challenge. The total playground size must be under 25MB, and the experience must take 3 minutes or less to demonstrate.

### 1. Data Mocking Strategy
- **Authentication**: Stripped out `FirebaseAuth`. The user starts automatically signed into a local Guest account.
- **Databases**: Stripped out `FirebaseFirestore`. Course lists, chapters, lessons, and progress are saved/retrieved locally using bundled JSON files and `UserDefaults`.
- **Screen Time APIs**: Apple's `DeviceActivity` and `FamilyControls` APIs require entitlements and extensions that don't operate inside Playgrounds or Simulators. They have been stripped entirely, and instead, we provide a **simulated UI overlay** (`MockScreenTimeService`) to demonstrate what happens when the user clicks a blocked app.

### 2. Included Core Views
- **Onboarding flow** (Hours Reclaimed -> Commitment)
- **Main Tab View**
- **Journey View** (The mountain path visualization)
- **Courses/Library Lists**
- **Profile View** (Simplified stats bento box)
- **Lesson Engine** (Interactive taps & knowledge checks)

### 3. Removed Libraries & Dependencies
- `Firebase`
- `SuperwallKit`
- `StoreKit`
- Background extensions
- Any forms of remote configuration or cloud fetching

### 4. Media & Assets Strategy
- Images are fully local. The `CachedAsyncImage` logic has been patched to retrieve directly from the local bundle rather than downloading from the web.
- A select subset of JSON courses (focus, habits, stoicism) limits the binary size, easily keeping the `Everest.swiftpm` under 25MB limit.
