////
////  AppDelegate.swift
////  ChickenEggs BubbleBlitz
////
//
//import UIKit
//import SwiftUI
//import Skillz
//
//@objc(AppDelegate)
//class AppDelegate: UIResponder, UIApplicationDelegate, SkillzDelegate {
//    
//    var window: UIWindow?
//    static var shared: AppDelegate {
//        return UIApplication.shared.delegate as! AppDelegate
//    }
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        print("AppDelegate: application didFinishLaunching")
//        
//        // Setup Window manually FIRST (ensures hierarchy is ready)
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = UIHostingController(rootView: SplashView())
//        self.window = window
//        window.makeKeyAndVisible()
//        
//        // Initialize Skillz with Game ID 97952 AFTER window is visible
//        // We'll use .sandbox for now; this can be changed to .production later
//        Skillz.skillzInstance().initWithGameId("97952", for: self, with: .sandbox, allowExit: false)
//        
//        return true
//    }
//    
//    // MARK: - SkillzDelegate Implementation
//    
//    func tournamentWillBegin(_ gameParameters: [AnyHashable : Any], with matchInfo: SKZMatchInfo) {
//        print("Skillz: Tournament will begin")
//        // Implementation for starting the game will go here
//    }
//    
//    func skillzWillExit() {
//        print("Skillz: SDK will exit")
//    }
//}


//
//  AppDelegate.swift
//  ChickenEggs BubbleBlitz
//

import UIKit
import SwiftUI
import Skillz

@objc(AppDelegate)
class AppDelegate: UIResponder, UIApplicationDelegate, SkillzDelegate {
    
    var window: UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("AppDelegate: application didFinishLaunching")
        
        // Setup Window manually FIRST (ensures hierarchy is ready)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: SplashView())
        self.window = window
        window.makeKeyAndVisible()
        
        // Initialize Skillz with Game ID 97952 AFTER window is visible
        // We'll use .sandbox for testing; change to .production when ready to publish
        Skillz.skillzInstance().initWithGameId("97952", for: self, with: .production, allowExit: false)
        
        print("Skillz SDK initialized in SANDBOX mode")
        
        return true
    }
    
    // MARK: - SkillzDelegate Implementation
    
    func tournamentWillBegin(_ gameParameters: [AnyHashable : Any], with matchInfo: SKZMatchInfo) {
        print("========================================")
        print("Skillz: Tournament will begin")
        print("Match Info: \(matchInfo)")
        print("Game Parameters: \(gameParameters)")
        print("========================================")
        
        // Extract custom game parameters (if configured in Skillz dashboard)
        let startLevel = (gameParameters["startLevel"] as? Int) ?? 1
        let difficulty = (gameParameters["difficulty"] as? String) ?? "normal"
        
        print("Starting Level: \(startLevel)")
        print("Difficulty: \(difficulty)")
        
        // Get the root view controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("❌ Error: Could not get root view controller")
            return
        }
        
        // Create the game view for tournament mode
        let gameView = MainGameView(
            startingLevel: startLevel,
            isSkillzTournament: true,
            skillzMatchInfo: matchInfo
        )
        .environmentObject(SoundManager.shared)
        
        let hostingController = UIHostingController(rootView: gameView)
        hostingController.modalPresentationStyle = .fullScreen
        
        // Present the game
        DispatchQueue.main.async {
            rootViewController.present(hostingController, animated: true) {
                print("✅ Tournament game presented successfully")
            }
        }
    }
    
    func skillzWillExit() {
        print("========================================")
        print("Skillz: SDK will exit - Returning to main menu")
        print("========================================")
        
        // Return to main menu
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("❌ Error: Could not get window")
            return
        }
        
        DispatchQueue.main.async {
            // Dismiss any presented view controllers first
            if let presentedViewController = window.rootViewController?.presentedViewController {
                presentedViewController.dismiss(animated: false) {
                    // Return to splash/menu
                    window.rootViewController = UIHostingController(rootView: SplashView())
                    print("✅ Returned to main menu")
                }
            } else {
                // Directly return to splash/menu
                window.rootViewController = UIHostingController(rootView: SplashView())
                print("✅ Returned to main menu")
            }
        }
    }
}
