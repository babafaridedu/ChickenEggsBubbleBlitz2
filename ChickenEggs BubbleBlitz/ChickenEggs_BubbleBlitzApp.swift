
import SwiftUI


struct ChickenEggs_BubbleBlitzApp: App {
    @StateObject private var soundManager = SoundManager.shared
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(soundManager)
        }
    }
}
