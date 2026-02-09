

import SwiftUI
import Skillz


// MARK: - Updated Splash View to navigate to Menu

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        NavigationStack {
            ZStack {
                if isActive {
                    MainGameMenuView()
                } else {
                    ZStack {
                        // Background with image
                        Image("background")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()

                        VStack {
                            
                            VStack {

                                Text("ChickenEggs\nBubbleBlitz")
                                    .font(.system(size: 38, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: .red, radius: 10, x: -2, y: 0)
                                    .shadow(color: .green, radius: 10, x: 2, y: 0)
                                    .shadow(color: .white.opacity(0.8), radius: 5, x: 0, y: 0)
                                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                                    .padding(.top, 8)
                            
                                Image("chicken")
                                    .resizable()
                                    .frame(width: 200,height: 180)
                                    .padding(.bottom,20)
                                
                            }
                            
                        }
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2)) {
                                self.size = 1.0
                                self.opacity = 1.0
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Timer View Component
struct TimerCircleView: View {
    let timeRemaining: Int
    let totalTime: Int
    let isRunning: Bool
    
    private var progress: Double {
        return Double(timeRemaining) / Double(totalTime)
    }
    
    private var timerColor: Color {
        if progress > 0.6 {
            return .green
        } else if progress > 0.3 {
            return .orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color.black.opacity(0.7))
                .frame(width: 80, height: 80)
            
            // Progress circle
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [timerColor, timerColor.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 70, height: 70)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1.0), value: progress)
            
            // Timer text
            VStack(spacing: 2) {
                Text(formatTime(timeRemaining))
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                
                if !isRunning {
                    Text("Paused")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.yellow)
                }
            }
        }
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 3)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Game Over View
struct GameOverView: View {
    let level: Int
    let score: Int
    let onRestart: () -> Void
    let onMenu: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Game Over Title
                VStack(spacing: 10) {
                    Text("Time's Up!")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.red)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                    
                    Text("Game Over")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Level Info
                VStack(spacing: 8) {
                    Text("Level \(level) Incomplete")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.orange)
                    
                    Text("You ran out of time!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Score
                VStack(spacing: 5) {
                    Text("Score Lost")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(score) points")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.yellow)
                }
                
                // Buttons
                VStack(spacing: 15) {
                    Button(action: onRestart) {
                        Text("Play Again Level \(level)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    
                    Button(action: onMenu) {
                        Text("Back to Menu")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
            )
            .padding(30)
        }
    }
}

// MARK: - All Levels Complete View
struct AllLevelsCompleteView: View {
    let totalScore: Int
    let totalEggsCollected: Int
    let onRestartGame: () -> Void
    
    var body: some View {
        ZStack {
            // Animated background
            LinearGradient(
                colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8), Color.green.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Confetti effect
            ForEach(0..<30, id: \.self) { i in
                ConfettiPieceView()
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: -100...0)
                    )
            }
            
            VStack(spacing: 30) {
                // Title
                VStack(spacing: 10) {
                    Text("🎉 Congratulations! 🎉")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                    
                    Text("All Levels Complete!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.yellow)
                }
                
                // Trophy Icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                
                // Stats
                VStack(spacing: 20) {
                    StatView(icon: "star.fill", title: "Total Score", value: "\(totalScore) points", color: .yellow)
                    
                    StatView(icon: "egg.fill", title: "Eggs Collected", value: "\(totalEggsCollected) eggs", color: .orange)
                    
                    StatView(icon: "flag.checkered", title: "Levels Completed", value: "5/5 levels", color: .green)
                }
                
                // Final Message
                Text("You've mastered Chicken Bubble Blitz!")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Restart Button
                Button(action: onRestartGame) {
                    Text("Play Again From Start")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [Color.orange, Color.red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 8)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.black.opacity(0.7))
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.4), lineWidth: 3)
                    )
            )
            .padding(30)
        }
    }
}

struct StatView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct ConfettiPieceView: View {
    @State private var yOffset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1.0
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    let shapes: [String] = ["circle.fill", "square.fill", "triangle.fill", "diamond.fill"]
    
    var body: some View {
        let randomColor = colors.randomElement() ?? .yellow
        let randomShape = shapes.randomElement() ?? "circle.fill"
        
        Image(systemName: randomShape)
            .font(.system(size: CGFloat.random(in: 8...15)))
            .foregroundColor(randomColor)
            .offset(y: yOffset)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeIn(duration: Double.random(in: 3.0...6.0))
                    .repeatForever(autoreverses: false)
                ) {
                    yOffset = UIScreen.main.bounds.height + 100
                    rotation = Double.random(in: 360...1080)
                }
                
                withAnimation(
                    .easeIn(duration: Double.random(in: 4.0...7.0))
                    .repeatForever(autoreverses: false)
                ) {
                    opacity = 0.0
                }
            }
    }
}


struct LevelBackgroundView: View {
    let currentLevel: Int
    
    var backgroundImageName: String {
        switch currentLevel {
        case 1:
            return "game_background_level1"
        case 2:
            return "game_background_level2"
        case 3:
            return "game_background_level3"
        case 4:
            return "game_background_level4"
        case 5:
            return "game_background_level5"
        default:
            return "game_background"
        }
    }
    
    var body: some View {
        
        
        GeometryReader { geometry in
            Image(backgroundImageName)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .overlay(Color.black.opacity(0.5))
        }
        .ignoresSafeArea()
    
    }
}

// MARK: - Updated Main Game View with Timer
struct MainGameView: View {
    
    @State private var progress: CGFloat = 0.0
    @State private var score: Int = 0
    @State private var collectedEggs: Int = 0
    @State private var currentLevel: Int = 1

    var startingLevel: Int = 1
    
    // Skillz Integration Properties
    var isSkillzTournament: Bool = false
    var skillzMatchInfo: SKZMatchInfo? = nil
    
    @State private var finalScoreReported: Bool = false

    // Timer States
    @State private var timeRemaining: Int = 90 // Default 1.5 minutes
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isTimerRunning: Bool = true
    @State private var showGameOver: Bool = false
    @State private var showAllLevelsComplete: Bool = false
    
    // Track total game stats
    @State private var totalGameScore: Int = 0
    @State private var totalGameEggs: Int = 0
    @State private var levelStartScore: Int = 0 // Track score at level start
    
    @State private var availableBalls = ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"]
    @State private var basketBalls = ["red_ball", "blue_ball", "yellow_ball", "green_ball","purple_ball", "orange_ball"]
    @State private var currentThrowBall = "red_ball"
    @State private var isChangingBall = false
    @State private var flyingBall: String? = nil
    @State private var flyingBallPosition: CGPoint = .zero
    @State private var flyingBallScale: CGFloat = 1.0
    
    // Game state
    @State private var ballPositions: [BallPosition] = []
    @State private var eggPositions: [EggPosition] = []
    @State private var flyingEggs: [FlyingEgg] = []
    @State private var flyingBalls: [FlyingBall] = []
    @State private var pointsToasts: [PointsToast] = []
    @State private var confettiPieces: [ConfettiPiece] = []
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var showLevelComplete: Bool = false
    @State private var isTransitioningLevel: Bool = false
    
    // NEW: Baskets with eggs for level 1
    @State private var baskets: [BasketWithEggs] = []
    
    // Line drawing state
    @State private var isDrawingLine = false
    @State private var lineStartPoint: CGPoint = .zero
    @State private var lineEndPoint: CGPoint = .zero
    @State private var throwBallPosition: CGPoint = .zero
    @State private var ballOrigin: CGPoint = .zero
    
    // Animation states
    @State private var disappearingBalls: [UUID] = []
    
    // Header position tracking
    @State private var headerEggPosition: CGPoint = .zero
    
    // Circle level center point
    @State private var circleLevelCenter: CGPoint = .zero
    
    // Targeting
    @State private var currentTargetLine: Int? = nil
    @State private var showHitZoneHint: Bool = false
    
    // Screen dimensions for responsive design
    @State private var screenSize: CGSize = .zero
    
    // ADD this property to track visible balls count
    @State private var visibleBallsCount: Int = 0
    
    @Environment(\.dismiss) private var dismiss
    
    // Add these with your other @State variables
    @State private var timerPosition: CGPoint = .zero
    @State private var isDraggingTimer = false
    
    @EnvironmentObject private var soundManager: SoundManager
    
    // Timer for each level (in seconds)
    private var levelTimers: [Int] {
        [
            90,  // Level 1: 1.5 minutes
            120, // Level 2: 2 minutes
            150, // Level 3: 2.5 minutes
            180, // Level 4: 3 minutes
            210  // Level 5: 3.5 minutes
        ]
    }
    
    // MARK: - Skillz Score Reporting
    
    private func reportScoreToSkillz(finalScore: Int) {
        guard isSkillzTournament else {
            print("ℹ️ Not in Skillz tournament, score not reported")
            return
        }
        
        guard !finalScoreReported else {
            print("⚠️ Score already reported, skipping duplicate report")
            return
        }
        
        print("========================================")
        print("📊 REPORTING SCORE TO SKILLZ")
        print("Final Score: \(finalScore)")
        print("Total Eggs Collected: \(totalGameEggs)")
        print("Levels Completed: \(currentLevel)/5")
        print("========================================")
        
        finalScoreReported = true
        
        // Report the score to Skillz
        Task {
            await Skillz.skillzInstance().displayTournamentResults(withScore: NSNumber(value: finalScore))
        }
        
        print("✅ Score reported successfully to Skillz")
    }
    
    private func shouldReportScore() -> Bool {
        // Report score when:
        // 1. All levels are completed, OR
        // 2. Time runs out
        return isSkillzTournament && !finalScoreReported
    }
    

    
    var body: some View {

        GeometryReader { geometry in
            ZStack {

                // Background - Different for each level
                LevelBackgroundView(currentLevel: currentLevel)
            
                VStack(spacing: 10) {
                    // Header
                    ZStack {
                        Color.white
                            .cornerRadius(25)
                        
                        HStack {
                            
                            // Back Button
                            Button(action: {
                                pauseTimer()
                                
                                // Check if in Skillz tournament
                                if isSkillzTournament {
                                    // Show confirmation alert logic inside handleBackToMenu
                                    handleBackToMenu()
                                } else {
                                    dismiss()
                                    handleBackToMenu()
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.blue)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(15)
                            }
                            
                            Text("\(score)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.orange)
                            
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text("Level \(currentLevel)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.purple)
                                
                                ProgressBarView(progress: progress, levels: 5)
                                    .frame(height: 8)
                                    .padding(.horizontal, 10)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Image("egg_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear
                                                .onAppear {
                                                    updateHeaderEggPosition(from: geo)
                                                }
                                        }
                                    )
                                
                                Text("\(collectedEggs)/\(getTotalEggsForLevel())")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.top, 10)
                    
                    if isSkillzTournament {
                        VStack(spacing: 2) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text("TOURNAMENT")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.yellow)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                    }
                    
                    // Game Area
                    Group {
                        switch currentLevel {
                        case 1:
                            ThreeColumnsLevelView(
                                ballPositions: ballPositions,
                                eggPositions: eggPositions,
                                baskets: baskets,
                                disappearingBalls: disappearingBalls,
                                eggAtPosition: eggAtPosition,
                                ballAtPosition: ballAtPosition
                            )
                            .frame(height: geometry.size.height * 0.5)
                            .padding(.horizontal, 10)
                            
                        case 2:
                            TriangleLevelView(
                                ballPositions: ballPositions,
                                eggPositions: eggPositions,
                                disappearingBalls: disappearingBalls,
                                eggAtPosition: eggAtPosition,
                                ballAtPosition: ballAtPosition
                            )
                            .frame(height: geometry.size.height * 0.4)
                            .padding(.horizontal, 10)
                            
                        case 3:
                            HexagonLevelView(
                                ballPositions: ballPositions,
                                eggPositions: eggPositions,
                                disappearingBalls: disappearingBalls,
                                eggAtPosition: eggAtPosition,
                                ballAtPosition: ballAtPosition,
                                circleCenter: circleLevelCenter
                            )
                            .frame(height: geometry.size.height * 0.45)
                            .padding(.horizontal, 10)
                            .background(
                                GeometryReader { circleGeometry in
                                    Color.clear
                                        .onAppear {
                                            updateCircleLevelCenter(from: circleGeometry, in: geometry)
                                        }
                                }
                            )
                            
                        case 4:
                            RectangleLevelView(
                                ballPositions: ballPositions,
                                eggPositions: eggPositions,
                                disappearingBalls: disappearingBalls,
                                eggAtPosition: eggAtPosition,
                                ballAtPosition: ballAtPosition
                            )
                            .frame(height: geometry.size.height * 0.4)
                            .padding(.horizontal, 10)
                            
                        case 5:
                            CircleLevelView(
                                ballPositions: ballPositions,
                                eggPositions: eggPositions,
                                disappearingBalls: disappearingBalls,
                                eggAtPosition: eggAtPosition,
                                ballAtPosition: ballAtPosition,
                                circleCenter: circleLevelCenter
                            )
                            .frame(height: geometry.size.height * 0.45)
                            .padding(.horizontal, 10)
                            .background(
                                GeometryReader { circleGeometry in
                                    Color.clear
                                        .onAppear {
                                            updateCircleLevelCenter(from: circleGeometry, in: geometry)
                                        }
                                }
                            )
                            
                        default:
                            EmptyView()
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom Section with Chicken and Basket
                    HStack {
                        ZStack {
                            Image("chicken")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.30)
                            
                            // Throw Ball
                            GlowingGlassBall(ballType: currentThrowBall, size: 50)
                                .offset(x: geometry.size.width * 0.13, y: -geometry.size.height * -0.04)
                                .scaleEffect(flyingBallScale)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .onAppear {
                                                updateThrowBallPosition(from: geo)
                                            }
                                    }
                                )
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let globalLocation = CGPoint(
                                                x: ballOrigin.x + value.location.x,
                                                y: ballOrigin.y + value.location.y
                                            )
                                            
                                            if !isDrawingLine {
                                                isDrawingLine = true
                                                lineStartPoint = throwBallPosition
                                                lineEndPoint = globalLocation
                                            }
                                            
                                            lineEndPoint = globalLocation
                                            _ = getTargetLine(from: globalLocation)
                                        }
                                        .onEnded { value in
                                            let globalLocation = CGPoint(
                                                x: ballOrigin.x + value.location.x,
                                                y: ballOrigin.y + value.location.y
                                            )
                                            handleThrowRelease(at: globalLocation)
                                            resetLineDrawing()
                                        }
                                )
                            
                            
                            // "Drag Ball Up" Button
                            VStack {
                                Button(action: {
                                    // Optional: Add any action you want when button is tapped
                                }) {
                                    Text("Drag Ball Up")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.orange)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                        )
                                }
                                .offset(x: geometry.size.width * 0.13, y: geometry.size.height * 0.09)
                            }
                        }
                        
                        Spacer()
                        
                        // Basket and Controls
                        VStack(spacing: 15) {
                            CustomBasketView(balls: basketBalls)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.1)
                                .onTapGesture {
                                    changeBall()
                                }
                            
                            Button(action: {
                                changeBall()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .font(.system(size: 16))
                                    Text("Change Ball")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                }
                .opacity(isTransitioningLevel ? 0.3 : 1.0)
                .disabled(isTransitioningLevel || showGameOver || showAllLevelsComplete)
            
                
                // Timer Circle - Draggable and Floating
                TimerCircleView(
                    timeRemaining: timeRemaining,
                    totalTime: levelTimers[currentLevel - 1],
                    isRunning: isTimerRunning
                )
                .position(timerPosition)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDraggingTimer = true
                            timerPosition = value.location
                        }
                        .onEnded { _ in
                            isDraggingTimer = false
                            // Optional: Snap to edges or save position
                        }
                )
                .onAppear {
                    // Initialize timer position to center if not set
                    if timerPosition == .zero {
                        timerPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
                
                
                // Flying Ball Animation
                if let flyingBall = flyingBall {
                    FlyingGlowingBall(ballType: flyingBall, size: 40)
                        .position(flyingBallPosition)
                        .scaleEffect(flyingBallScale)
                }

                ForEach(flyingEggs) { egg in
                    if egg.isVisible {
                        Image("egg_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150) // MUCH LARGER SIZE - 150x150
                            .position(egg.position)
                            .scaleEffect(egg.scale)
                            .zIndex(1000) // Ensure eggs appear on top
                    }
                }

                
                // MARK: - UPDATE points toast rendering
                ForEach(pointsToasts) { pointsToast in
                    if pointsToast.isVisible {
                        Text(pointsToast.text)
                            .font(.system(size: 28, weight: .heavy)) // LARGER FONT
                            .foregroundColor(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    colors: [Color.orange, Color.yellow],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                            .scaleEffect(pointsToast.scale)
                            .opacity(pointsToast.opacity)
                            .position(pointsToast.position)
                            .zIndex(1001) // Ensure toasts appear on top of eggs
                    }
                }
                
                
                // Flying Balls Animation
                ForEach(flyingBalls) { flyingBall in
                    if flyingBall.isVisible {
                        FlyingGlowingBall(
                            ballType: flyingBall.ballType,
                            size: 35,
                            scale: flyingBall.scale,
                            rotation: flyingBall.rotation
                        )
                        .position(flyingBall.position)
                    }
                }
                
                // Confetti Pieces
                ForEach(confettiPieces) { confetti in
                    if confetti.isVisible {
                        Circle()
                            .fill(confetti.color)
                            .frame(width: 8, height: 8)
                            .position(confetti.position)
                            .scaleEffect(confetti.scale)
                            .rotationEffect(.degrees(confetti.rotation))
                    }
                }
                
                // Line Drawing
                if isDrawingLine {
                    Path { path in
                        path.move(to: lineStartPoint)
                        path.addLine(to: lineEndPoint)
                    }
                    .stroke(
                        LinearGradient(
                            colors: [Color.orange.opacity(0.8), Color.red.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, dash: [5, 3])
                    )
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                }
                
                // Hit Zone Indicators for Circular Levels
                if (currentLevel == 3 || currentLevel == 5) && currentTargetLine != nil && isDrawingLine {
                    let totalLines = currentLevel == 3 ? 6 : 6
                    ForEach(0..<totalLines, id: \.self) { lineIndex in
                        if lineIndex == currentTargetLine {
                            let angle = Double(lineIndex) * (2 * .pi / Double(totalLines))
                            let innerRadius: CGFloat = currentLevel == 3 ? 30 : 40
                            let outerRadius: CGFloat = min(geometry.size.width, geometry.size.height) * (currentLevel == 3 ? 0.25 : 0.3)
                            let centerX = circleLevelCenter.x
                            let centerY = circleLevelCenter.y
                            
                            let startX = centerX + cos(angle - 0.2) * innerRadius
                            let startY = centerY + sin(angle - 0.2) * innerRadius
                            let endX = centerX + cos(angle + 0.2) * outerRadius
                            let endY = centerY + sin(angle + 0.2) * outerRadius
                            
                            Path { path in
                                path.move(to: CGPoint(x: startX, y: startY))
                                path.addLine(to: CGPoint(x: endX, y: endY))
                            }
                            .stroke(
                                LinearGradient(
                                    colors: [Color.green.opacity(0.8), Color.yellow.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                            )
                        }
                    }
                }
                
                // Level Complete Overlay
                if showLevelComplete {
                    LevelCompleteView(
                        level: currentLevel,
                        onContinue: {
                            transitionToNextLevel()
                        }
                    )
                }
                
                // Game Over Overlay
                if showGameOver {
                    GameOverView(
                        level: currentLevel,
                        score: score - levelStartScore, // Only show score earned in this level
                        onRestart: {
                            restartCurrentLevel()
                        },
                        onMenu: {
                            dismiss()
                        }
                    )
                }
                
                // All Levels Complete Overlay
                if showAllLevelsComplete {
                    AllLevelsCompleteView(
                        totalScore: totalGameScore,
                        totalEggsCollected: totalGameEggs,
                        onRestartGame: {
                            restartEntireGame()
                        }
                    )
                }
                
                // Toast Message
                if showToast {
                    VStack {
                        Spacer()
                        Text(toastMessage)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.red.opacity(0.9))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .padding(.bottom, 100)
                }
                
                // Hit Zone Hint Message
                if showHitZoneHint {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 20))
                            
                            Text("Aim between the inner and outer circles!")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .padding(.bottom, 120)
                    .transition(.scale.combined(with: .opacity))
                }
            }
          
            .onAppear {

                // Log tournament status
                if isSkillzTournament {
                    print("========================================")
                    print("🏆 SKILLZ TOURNAMENT MODE ACTIVE")
                    print("Match Info: \(skillzMatchInfo?.description ?? "N/A")")
                    print("========================================")
                } else {
                    print("ℹ️ Playing in NORMAL MODE (not tournament)")
                }
                
                screenSize = geometry.size
                      lineStartPoint = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                      lineEndPoint = lineStartPoint
                      
                      // Initialize timer position
                      if timerPosition == .zero {
                          timerPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                      }
                      
                      currentLevel = startingLevel // SET THE STARTING LEVEL
                      initializeGamePositions()
                      updateVisibleBallsCount()
                      startTimerForCurrentLevel()
            }
            
            .onChange(of: geometry.size) { oldSize, newSize in
                screenSize = newSize
            }
            .onReceive(timer) { _ in
                if isTimerRunning && !showLevelComplete && !showGameOver && !showAllLevelsComplete {
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                        
                        // Show warning when time is running low
                        if timeRemaining == 30 {
                            showToast(message: "30 seconds remaining!")
                        } else if timeRemaining == 10 {
                            showToast(message: "10 seconds left! Hurry up!")
                        }
                    } else {
                        // Time's up!
                        handleTimeUp()
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - UPDATED getCollectibleEggs method for Triangle Level
    private func getCollectibleEggs(lineIndex: Int) -> [EggPosition] {
        // Get all uncollected eggs in this line
        let uncollectedEggs = eggPositions.filter {
            $0.lineIndex == lineIndex &&
            $0.isVisible &&
            !$0.isCollected
        }
        
        var collectibleEggs: [EggPosition] = []
        
        // For Triangle Level (Level 2), we need different logic
        if currentLevel == 2 {
            // For triangle level, collect ALL eggs in the row when balls are cleared
            // Don't check for "collectibility" based on position
            collectibleEggs = uncollectedEggs.sorted { $0.positionIndex < $1.positionIndex }
            print("Triangle Level - Found \(collectibleEggs.count) eggs in row \(lineIndex)")
        } else {
            // For other levels, use the existing logic
            for egg in uncollectedEggs.sorted(by: { $0.positionIndex < $1.positionIndex }) {
                if isEggCollectible(egg: egg) {
                    collectibleEggs.append(egg)
                } else {
                    break
                }
            }
        }
        
        print("Total collectible eggs in line \(lineIndex): \(collectibleEggs.count)")
        return collectibleEggs
    }

    // MARK: - UPDATED isEggCollectible method for Triangle Level
    private func isEggCollectible(egg: EggPosition) -> Bool {
        switch currentLevel {
        case 2:
            // For Triangle level, eggs are ALWAYS collectible when the row is hit
            // because we're clearing the entire row at once
            return true
            
        case 3, 5:
            // Hexagon and Circle levels - check balls between center and egg
            let ballsBetween = ballPositions.filter {
                $0.lineIndex == egg.lineIndex &&
                $0.positionIndex > 0 &&
                $0.positionIndex < egg.positionIndex &&
                $0.isVisible
            }
            return ballsBetween.isEmpty
            
        case 4:
            // Rectangle level - check balls below the egg
            let ballsBelow = ballPositions.filter {
                $0.lineIndex == egg.lineIndex &&
                $0.positionIndex > egg.positionIndex &&
                $0.isVisible
            }
            return ballsBelow.isEmpty
            
        default:
            return true
        }
    }

    // MARK: - UPDATED collectEgg method with proper points calculation
    private func collectEgg(egg: EggPosition) {
        if let eggIndex = eggPositions.firstIndex(where: { $0.id == egg.id }) {
            eggPositions[eggIndex].isCollected = true
            
            // Different points for different levels
            let points: Int
            switch currentLevel {
            case 1: points = 100  // Three Columns level
            case 2: points = 80   // Triangle level - 80 points PER EGG
            case 3: points = 120  // Hexagon level - medium
            case 4: points = 100  // Rectangle level
            case 5: points = 150  // Circle level - hardest
            default: points = 100
            }
            
            score += points
            collectedEggs += 1
            updateProgress()
            
            print("Collected egg at line \(egg.lineIndex), position \(egg.positionIndex) - +\(points) points")
            
            showPointsToast(egg: eggPositions[eggIndex], points: points)
            animateEggCollection(egg: eggPositions[eggIndex])
        }
    }
    
    
    // MARK: - UPDATED animateBallCollision with sound
    private func animateBallCollision(lineIndex: Int) {
        let ballsInLine = ballPositions.filter {
            $0.lineIndex == lineIndex && $0.isVisible
        }.sorted {
            // For all column-based levels, remove from bottom to top
            return $0.positionIndex > $1.positionIndex
        }
        
        guard !ballsInLine.isEmpty else {
            checkEggCollection(lineIndex: lineIndex)
            return
        }
        
        // PLAY BALL HIT SOUND
        soundManager.playSound(named: "ball_hit")
        
        createFlyingBallsAnimation(for: ballsInLine)
        
        // Mark balls as not visible
        for ball in ballsInLine {
            if let ballIndex = ballPositions.firstIndex(where: { $0.id == ball.id }) {
                ballPositions[ballIndex].isVisible = false
            }
        }
        
        updateVisibleBallsCount()
        
        // Check egg collection immediately after balls disappear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkEggCollection(lineIndex: lineIndex)
        }
    }
    

    // MARK: - ADD Debug method to check egg positions
    private func debugEggPositions(lineIndex: Int) {
        let eggsInLine = eggPositions.filter {
            $0.lineIndex == lineIndex &&
            $0.isVisible &&
            !$0.isCollected
        }
        print("DEBUG - Line \(lineIndex): \(eggsInLine.count) uncollected eggs")
        for egg in eggsInLine {
            print("  - Egg at position \(egg.positionIndex), collected: \(egg.isCollected)")
        }
    }

    // MARK: - UPDATE initializeTriangleLevel to ensure proper egg placement
    private func initializeTriangleLevel() {
        let ballColors = ["red_ball", "blue_ball", "yellow_ball"]
        
        ballPositions.removeAll()
        eggPositions.removeAll()
        baskets.removeAll()
        
        // Triangle pattern - 3 lines with decreasing balls per row
        for lineIndex in 0..<3 {
            let ballsInLine = 3 - lineIndex // 3, 2, 1 balls per line
            
            for positionIndex in 0..<ballsInLine {
                ballPositions.append(BallPosition(
                    lineIndex: lineIndex,
                    positionIndex: positionIndex,
                    ballType: ballColors[lineIndex]
                ))
            }
        }
        
        // UPDATED: Add eggs at ALL positions to ensure they're there
        // Row 0 (Red): 3 eggs at positions 0, 1, 2
        eggPositions.append(EggPosition(lineIndex: 0, positionIndex: 0, isVisible: true, isCollected: false))
        eggPositions.append(EggPosition(lineIndex: 0, positionIndex: 1, isVisible: true, isCollected: false))
        eggPositions.append(EggPosition(lineIndex: 0, positionIndex: 2, isVisible: true, isCollected: false))
        
        // Row 1 (Blue): 2 eggs at positions 0, 1
        eggPositions.append(EggPosition(lineIndex: 1, positionIndex: 0, isVisible: true, isCollected: false))
        eggPositions.append(EggPosition(lineIndex: 1, positionIndex: 1, isVisible: true, isCollected: false))
        
        // Row 2 (Yellow): 1 egg at position 0
        eggPositions.append(EggPosition(lineIndex: 2, positionIndex: 0, isVisible: true, isCollected: false))
        
        print("Triangle Level Initialized:")
        print("  - Row 0 (Red): 3 eggs")
        print("  - Row 1 (Blue): 2 eggs")
        print("  - Row 2 (Yellow): 1 egg")
        
        updateVisibleBallsCount()
    }
    
    
    // MARK: - UPDATED checkLevelCompletion method with proper level completion logic
    private func checkLevelCompletion() {
        let totalEggs = getTotalEggsForLevel()
        
        print("Checking level completion - Level: \(currentLevel), Collected Eggs: \(collectedEggs)/\(totalEggs), Visible Balls: \(visibleBallsCount)")
        
        let isCompleted: Bool
        
        switch currentLevel {
        case 1:
            // For Three Columns level, check if all baskets are empty AND no balls are left
            let allBasketsEmpty = baskets.allSatisfy { $0.eggs == 0 }
            let noBallsLeft = visibleBallsCount == 0
            isCompleted = allBasketsEmpty && noBallsLeft
            
        case 2, 3, 4, 5:
            // For other levels, check if ALL eggs are collected AND no balls are left
            let allEggsCollected = collectedEggs >= totalEggs
            let noBallsLeft = visibleBallsCount == 0
            isCompleted = allEggsCollected && noBallsLeft
            
        default:
            isCompleted = false
        }
        
        if isCompleted {
            print("LEVEL \(currentLevel) COMPLETE! Stopping timer...")
            stopTimer() // Stop timer when level is completed
            
            // ADD THIS CHECK to prevent premature level 5 completion
            if currentLevel < 5 {
                showLevelCompleteWithConfetti()
            } else {
                // Only show all levels complete when actually on level 5 AND completed
                totalGameScore += score
                totalGameEggs += collectedEggs
                showAllLevelsComplete = true
            }
        }
    }
    
    // MARK: - ADD method to debug flying eggs
    private func debugFlyingEggs() {
        print("Current flying eggs: \(flyingEggs.count)")
        for (index, egg) in flyingEggs.enumerated() {
            print("  Egg \(index): position \(egg.position), scale \(egg.scale), visible \(egg.isVisible)")
        }
    }
    
    // MARK: - UPDATE checkEggCollection to ensure ALL eggs are processed
    private func checkEggCollection(lineIndex: Int) {
        if currentLevel == 1 {
            // For Three Columns level, release eggs from basket
            releaseEggsFromBasket(columnIndex: lineIndex)
        } else {
            // For other levels, use existing egg collection logic
            let collectibleEggs = getCollectibleEggs(lineIndex: lineIndex)
            
            print("Found \(collectibleEggs.count) collectible eggs in line \(lineIndex)")
            
            // Collect ALL eggs IMMEDIATELY without delay between them
            for egg in collectibleEggs {
                collectEgg(egg: egg)
            }
            
            // Check level completion after egg collection
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.checkLevelCompletion()
            }
        }
    }
    

    private func animateEggCollection(egg: EggPosition) {
          let eggStartPosition = getEggScreenPosition(egg: egg)
          
          let flyingEgg = FlyingEgg(
              position: eggStartPosition,
              scale: 1.5 // START WITH LARGER SIZE
          )
          
          flyingEggs.append(flyingEgg)
          
          // PLAY EGG FLYING SOUND
          soundManager.playSound(named: "egg_flying")
          
          // Add some random offset to make multiple eggs visible
          let randomOffset = CGFloat.random(in: -20...20)
          let modifiedStartPosition = CGPoint(x: eggStartPosition.x + randomOffset, y: eggStartPosition.y + randomOffset)
          
          print("Animating collected egg to header position: \(headerEggPosition)")
          
          // Animate with scale effect for larger appearance
          withAnimation(.easeInOut(duration: 1.2)) {
              if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                  flyingEggs[index].position = self.headerEggPosition
                  flyingEggs[index].scale = 1.2 // LARGER FINAL SIZE
              }
          }
          
          // Add bounce effect
          withAnimation(.interpolatingSpring(stiffness: 100, damping: 8)) {
              if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                  flyingEggs[index].scale = 1.8 // EVEN LARGER DURING ANIMATION
              }
          }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              withAnimation(.easeOut(duration: 0.2)) {
                  if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                      flyingEggs[index].scale = 1.2 // SETTLE TO FINAL SIZE
                  }
              }
          }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
              self.flyingEggs.removeAll { $0.id == flyingEgg.id }
          }
      }
      

    // MARK: - UPDATED releaseEggsFromBasket with sound
       private func releaseEggsFromBasket(columnIndex: Int) {
           guard let basketIndex = baskets.firstIndex(where: { $0.columnIndex == columnIndex }) else { return }
           
           let eggsToRelease = baskets[basketIndex].eggs
           
           if eggsToRelease > 0 {
               // PLAY EGG FLYING SOUND for basket eggs
               soundManager.playSound(named: "egg_flying")
               
               // Get basket position for animation
               let basketPosition = getBasketScreenPosition(columnIndex: columnIndex)
               
               // Update basket eggs count FIRST
               baskets[basketIndex].eggs = 0
               
               print("Releasing \(eggsToRelease) eggs from basket \(columnIndex)")
               
               // Release ALL eggs from this basket with staggered animation
               for eggIndex in 0..<eggsToRelease {
                   let points = 100 // Points per egg for Three Columns level
                   
                   // Stagger the animation for each egg
                   DispatchQueue.main.asyncAfter(deadline: .now() + Double(eggIndex) * 0.3) {
                       self.animateEggFromBasketToHeader(
                           from: basketPosition,
                           points: points,
                           eggIndex: eggIndex,
                           totalEggs: eggsToRelease
                       )
                   }
               }
               
               // Check level completion after all eggs are released
               DispatchQueue.main.asyncAfter(deadline: .now() + Double(eggsToRelease) * 0.3 + 1.0) {
                   self.checkLevelCompletion()
               }
           }
       }
    

    // MARK: - UPDATED animateEggFromBasketToHeader with LARGER EGG SIZE
    private func animateEggFromBasketToHeader(from position: CGPoint, points: Int, eggIndex: Int, totalEggs: Int) {
        let flyingEgg = FlyingEgg(position: position, scale: 1.8) // START WITH LARGER SIZE
        flyingEggs.append(flyingEgg)
        
        // Calculate slightly different starting positions for each egg to avoid overlap
        let eggOffset = CGFloat(eggIndex - totalEggs / 2) * 25
        let startPosition = CGPoint(x: position.x + eggOffset, y: position.y)
        
        // Show points toast for each egg
        let pointsToast = PointsToast(
            position: CGPoint(x: startPosition.x, y: startPosition.y - 40),
            text: "+\(points)"
        )
        pointsToasts.append(pointsToast)
        
        // Update score and collected eggs
        score += points
        collectedEggs += 1
        updateProgress()
        
        print("Animating egg \(eggIndex + 1) of \(totalEggs) to header position")
        
        // Animate egg flying directly to header with individual path
        let animationDuration = 1.5 + Double(eggIndex) * 0.15
        
        // First, animate to header position with scale effects
        withAnimation(.easeOut(duration: animationDuration)) {
            if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                flyingEggs[index].position = headerEggPosition
                flyingEggs[index].scale = 1.5 // LARGER FINAL SIZE
            }
        }
        
        // Add bounce animation for larger appearance
        withAnimation(.interpolatingSpring(stiffness: 80, damping: 6)) {
            if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                flyingEggs[index].scale = 2.0 // EVEN LARGER DURING FLIGHT
            }
        }
        
        // Animate points toast
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            if let index = pointsToasts.firstIndex(where: { $0.id == pointsToast.id }) {
                pointsToasts[index].scale = 1.3
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.8)) {
                if let index = pointsToasts.firstIndex(where: { $0.id == pointsToast.id }) {
                    pointsToasts[index].position.y -= 80
                    pointsToasts[index].opacity = 0.0
                }
            }
        }
        
        // Final scale adjustment
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration - 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                    flyingEggs[index].scale = 1.3 // FINAL SIZE WHEN REACHING HEADER
                }
            }
        }
        
        // Remove egg and toast after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.5) {
            self.flyingEggs.removeAll { $0.id == flyingEgg.id }
            self.pointsToasts.removeAll { $0.id == pointsToast.id }
        }
    }

    // MARK: - UPDATED FlyingEgg struct for larger size
    struct FlyingEgg: Identifiable {
        let id = UUID()
        var position: CGPoint
        var scale: CGFloat = 1.8 // DEFAULT LARGER SIZE
        var isVisible: Bool = true
    }

    
    // MARK: - UPDATED transitionToNextLevel to stop sounds
      private func transitionToNextLevel() {
          isTransitioningLevel = true
          showLevelComplete = false
          
          // STOP ALL SOUNDS when transitioning
          soundManager.stopAllSounds()
          
          // Update total game stats
          totalGameScore += score
          totalGameEggs += collectedEggs
          
          // ONLY proceed to next level if current level is less than 5
          if currentLevel < 5 {
              currentLevel += 1
              
              // Reset the game for the next level
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.initializeGamePositions()
                  self.startTimerForCurrentLevel()
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                      self.isTransitioningLevel = false
                  }
              }
          } else {
              // All levels completed!
              totalGameScore += score // Add final level score
              totalGameEggs += collectedEggs // Add final level eggs
              
              stopTimer()
              
              // REPORT SCORE TO SKILLZ if in tournament mode
              if shouldReportScore() {
                  reportScoreToSkillz(finalScore: totalGameScore)
                  // Don't show completion screen, Skillz will handle it
              } else {
                  showAllLevelsComplete = true
              }
          }
      }
      
    
    
    
    

    // MARK: - Timer Management Methods
    
    private func startTimerForCurrentLevel() {
        timeRemaining = levelTimers[currentLevel - 1]
        isTimerRunning = true
        levelStartScore = score // Track score at level start
    }
    
    private func pauseTimer() {
        isTimerRunning = false
    }
    
    private func resumeTimer() {
        isTimerRunning = true
    }
    
    private func stopTimer() {
        isTimerRunning = false
    }
    
    private func cancelTimer() {
        timer.upstream.connect().cancel()
    }

    
    // MARK: - UPDATED handleTimeUp to stop sounds
      private func handleTimeUp() {
          stopTimer()
          
          // STOP ALL SOUNDS when time is up
          soundManager.stopAllSounds()
          
          // Calculate final score
          let finalScore = totalGameScore + score
          
          // REPORT SCORE TO SKILLZ if in tournament mode
          if shouldReportScore() {
              reportScoreToSkillz(finalScore: finalScore)
              return
          }
          
          // Check if level is already completed
          if checkIfLevelCompleted() {
              // Level was completed before time ran out
              showLevelCompleteWithConfetti()
          } else {
              // Time ran out before completing level
              showGameOver = true
          }
      }
      
    
    private func checkIfLevelCompleted() -> Bool {
        let totalEggs = getTotalEggsForLevel()
        return collectedEggs >= totalEggs && visibleBallsCount == 0
    }

    // MARK: - UPDATED restart methods to stop sounds
    private func restartCurrentLevel() {
        // Don't allow restart in Skillz tournament
        if isSkillzTournament {
            print("⚠️ Cannot restart level in Skillz tournament")
            return
        }
        
        showGameOver = false
        
        // STOP ALL SOUNDS when restarting
        soundManager.stopAllSounds()
        
        // Reset only the current level score (subtract score earned in this level)
        score = levelStartScore
        collectedEggs = 0
        progress = 0.0
        
        // Reinitialize level positions
        initializeGamePositions()
        startTimerForCurrentLevel()
    }
    
    private func restartEntireGame() {
            // Don't allow restart in Skillz tournament
            if isSkillzTournament {
                print("⚠️ Cannot restart game in Skillz tournament")
                return
            }
            
            showAllLevelsComplete = false
            
            // STOP ALL SOUNDS when restarting entire game
            soundManager.stopAllSounds()
            
            // Reset all game state
            currentLevel = 1
            score = 0
            collectedEggs = 0
            progress = 0.0
            totalGameScore = 0
            totalGameEggs = 0
            
            // Reinitialize level positions
            initializeGamePositions()
            startTimerForCurrentLevel()
        }
    
    
    
    // ADD this method to debug header position
    private func debugHeaderPosition() {
        print("Header Egg Position: \(headerEggPosition)")
        print("Screen Size: \(screenSize)")
    }
    
    // Add this to handle when user goes back to menu
    private func handleBackToMenu() {
        // In Skillz tournament, use Skillz exit
        if isSkillzTournament {
            print("⚠️ Exiting Skillz tournament")
            // Report current score before exiting
            let finalScore = totalGameScore + score
            if !finalScoreReported {
                reportScoreToSkillz(finalScore: finalScore)
            }
            return
        }
        
        soundManager.stopAllSounds()
        dismiss()
    }
    
    // NEW: Animate egg from basket directly to header
    private func animateEggFromBasketToHeader(from position: CGPoint, points: Int, eggIndex: Int, totalEggs: Int, columnIndex: Int) {
        let flyingEgg = FlyingEgg(position: position)
        flyingEggs.append(flyingEgg)
        
        // Calculate slightly different starting positions for each egg to avoid overlap
        let eggOffset = CGFloat(eggIndex - totalEggs / 2) * 15
        let startPosition = CGPoint(x: position.x + eggOffset, y: position.y)
        
        // Show points toast for each egg
        let pointsToast = PointsToast(
            position: CGPoint(x: startPosition.x, y: startPosition.y - 30),
            text: "+\(points)"
        )
        pointsToasts.append(pointsToast)
        
        // Update score and collected eggs
        score += points
        collectedEggs += 1
        updateProgress()
        
        // Animate egg flying directly to header with individual path
        let animationDuration = 1.2 + Double(eggIndex) * 0.1
        
        // First, animate to header position
        withAnimation(.easeOut(duration: animationDuration)) {
            if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                flyingEggs[index].position = headerEggPosition
                flyingEggs[index].scale = 0.8
            }
        }
        
        // Add some rotation for visual effect
        withAnimation(.linear(duration: animationDuration)) {
            if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                // Just for visual effect, we can add a subtle scale change
            }
        }
        
        // Animate points toast
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            if let index = pointsToasts.firstIndex(where: { $0.id == pointsToast.id }) {
                pointsToasts[index].scale = 1.2
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.8)) {
                if let index = pointsToasts.firstIndex(where: { $0.id == pointsToast.id }) {
                    pointsToasts[index].position.y -= 60
                    pointsToasts[index].opacity = 0.0
                }
            }
        }
        
        // Remove egg and toast after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.3) {
            flyingEggs.removeAll { $0.id == flyingEgg.id }
            pointsToasts.removeAll { $0.id == pointsToast.id }
        }
    }
    
    
    
    // UPDATE the animateEggFromBasket method for multiple eggs
    private func animateEggFromBasket(from position: CGPoint, points: Int, eggIndex: Int, totalEggs: Int) {
        let flyingEgg = FlyingEgg(position: position)
        flyingEggs.append(flyingEgg)
        
        // Calculate slightly different starting positions for each egg to avoid overlap
        let eggOffset = CGFloat(eggIndex - totalEggs / 2) * 20
        let startPosition = CGPoint(x: position.x + eggOffset, y: position.y)
        
        // Show points toast for each egg
        let pointsToast = PointsToast(
            position: CGPoint(x: startPosition.x, y: startPosition.y - 30),
            text: "+\(points)"
        )
        pointsToasts.append(pointsToast)
        
        // Animate egg flying to header with individual path
        let animationDuration = 0.8 + Double(eggIndex) * 0.1
        
        withAnimation(.easeOut(duration: animationDuration)) {
            if let index = flyingEggs.firstIndex(where: { $0.id == flyingEgg.id }) {
                flyingEggs[index].position = headerEggPosition
                flyingEggs[index].scale = 0.7
            }
        }
        
        // Animate points toast
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            if let index = pointsToasts.firstIndex(where: { $0.id == pointsToast.id }) {
                pointsToasts[index].scale = 1.2
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.8)) {
                if let index = pointsToasts.firstIndex(where: { $0.id == pointsToast.id }) {
                    pointsToasts[index].position.y -= 60
                    pointsToasts[index].opacity = 0.0
                }
            }
        }
        
        // Remove egg and toast after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.3) {
            flyingEggs.removeAll { $0.id == flyingEgg.id }
            pointsToasts.removeAll { $0.id == pointsToast.id }
        }
    }
    
    // UPDATE the getBasketScreenPosition for better positioning
    private func getBasketScreenPosition(columnIndex: Int) -> CGPoint {
        let totalColumns = 3
        let playAreaWidth = screenSize.width * 0.8
        let columnWidth = playAreaWidth / CGFloat(totalColumns)
        let startX = (screenSize.width - playAreaWidth) / 2
        
        let x = startX + CGFloat(columnIndex) * columnWidth + columnWidth / 2
        let y = screenSize.height * 0.22 // Adjusted for larger basket size
        
        return CGPoint(x: x, y: y)
    }
    
    
    
    // MARK: - NEW: Initialize Three Columns Level
    private func initializeThreeColumnsLevel() {
        ballPositions.removeAll()
        eggPositions.removeAll()
        baskets.removeAll()
        
        let columnColors = ["red_ball", "green_ball", "orange_ball"]
        let eggsPerColumn = [2, 3, 4] // 2 eggs in first column, 3 in second, 4 in third
        
        // Initialize balls (4 balls per column)
        for columnIndex in 0..<3 {
            let ballType = columnColors[columnIndex]
            
            for positionIndex in 0..<4 {
                ballPositions.append(BallPosition(
                    lineIndex: columnIndex,
                    positionIndex: positionIndex,
                    ballType: ballType
                ))
            }
        }
        
        // Initialize baskets with eggs
        for columnIndex in 0..<3 {
            baskets.append(BasketWithEggs(
                columnIndex: columnIndex,
                ballType: columnColors[columnIndex],
                eggs: eggsPerColumn[columnIndex],
                maxEggs: eggsPerColumn[columnIndex]
            ))
        }
        
        updateVisibleBallsCount()
    }
    
    
    // MARK: - UPDATED initializeHexagonLevel method
    private func initializeHexagonLevel() {
        let ballColors = ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"]
        
        ballPositions.removeAll()
        eggPositions.removeAll()
        baskets.removeAll()
        
        // Hexagon pattern - 6 arms with 3 positions each
        for lineIndex in 0..<6 {
            for positionIndex in 1..<4 {
                // Add balls to most positions, but leave some spots for eggs
                let shouldAddBall = !(
                    (positionIndex == 3 && (lineIndex == 1 || lineIndex == 3 || lineIndex == 5)) ||
                    (positionIndex == 2 && lineIndex == 0)
                )
                
                if shouldAddBall {
                    ballPositions.append(BallPosition(
                        lineIndex: lineIndex,
                        positionIndex: positionIndex,
                        ballType: ballColors[lineIndex]
                    ))
                }
                
                // UPDATED: Add eggs at strategic positions - CONSISTENT 6 EGGS TOTAL
                let shouldAddEgg = (
                    (positionIndex == 3 && (lineIndex == 1 || lineIndex == 3 || lineIndex == 5)) ||
                    (positionIndex == 2 && (lineIndex == 0 || lineIndex == 2 || lineIndex == 4))
                )
                
                if shouldAddEgg {
                    eggPositions.append(EggPosition(
                        lineIndex: lineIndex,
                        positionIndex: positionIndex,
                        isVisible: true,
                        isCollected: false
                    ))
                }
            }
        }
        
        updateVisibleBallsCount()
    }
    
    // MARK: - UPDATED getTotalEggsForLevel method
    private func getTotalEggsForLevel() -> Int {
        switch currentLevel {
        case 1: return 9  // NEW: Three Columns level - 2 + 3 + 4 = 9 eggs
        case 2: return 6  // UPDATED: Triangle level - now has 6 eggs (3 in first row + 2 in second + 1 in third)
        case 3: return 6  // UPDATED: Hexagon level - consistent 6 eggs total
        case 4: return 6  // Rectangle level
        case 5: return 12 // Circle level
        default: return 6
        }
    }
    
    // MARK: - Game Logic Method
    
    private func initializeGamePositions() {
        ballPositions.removeAll()
        eggPositions.removeAll()
        baskets.removeAll()
        collectedEggs = 0
        
        switch currentLevel {
        case 1:
            initializeThreeColumnsLevel() // NEW: Three Columns level
        case 2:
            initializeTriangleLevel()
        case 3:
            initializeHexagonLevel()
        case 4:
            initializeRectangleLevel()
        case 5:
            initializeCircularLevel()
        default:
            initializeThreeColumnsLevel()
        }
        updateProgress()
    }
    
    private func initializeRectangleLevel() {
        let ballColors = ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"]
        let initialEggPositions = [2, 0, 4, 1, 3, 4]
        
        ballPositions.removeAll()
        eggPositions.removeAll()
        baskets.removeAll()
        
        // Initialize balls
        for lineIndex in 0..<6 {
            for positionIndex in 0..<6 {
                if initialEggPositions[lineIndex] != positionIndex {
                    ballPositions.append(BallPosition(
                        lineIndex: lineIndex,
                        positionIndex: positionIndex,
                        ballType: ballColors[lineIndex]
                    ))
                }
            }
        }
        
        // Initialize eggs
        for lineIndex in 0..<6 {
            let eggPositionIndex = initialEggPositions[lineIndex]
            eggPositions.append(EggPosition(
                lineIndex: lineIndex,
                positionIndex: eggPositionIndex,
                isVisible: true,
                isCollected: false
            ))
        }
        
        updateVisibleBallsCount()
    }
    
    private func initializeCircularLevel() {
        let ballColors = ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"]
        
        // Different egg positions for each arm to create variety
        let eggPositionsPerArm: [[Int]] = [
            [3, 5],  // Arm 0: eggs at positions 3 and 5
            [4, 5],  // Arm 1: eggs at positions 4 and 5
            [2, 4],  // Arm 2: eggs at positions 2 and 4
            [3, 5],  // Arm 3: eggs at positions 3 and 5
            [2, 5],  // Arm 4: eggs at positions 2 and 5
            [3, 4]   // Arm 5: eggs at positions 3 and 4
        ]
        
        // Clear existing positions
        ballPositions.removeAll()
        eggPositions.removeAll()
        baskets.removeAll()
        
        // Initialize balls and eggs in circular pattern
        for lineIndex in 0..<6 {
            let eggPositionsForThisArm = eggPositionsPerArm[lineIndex]
            
            for positionIndex in 1..<6 { // Start from 1 to skip center
                // Add balls only to positions that don't have eggs AND are not position 5
                if !eggPositionsForThisArm.contains(positionIndex) && positionIndex < 5 {
                    ballPositions.append(BallPosition(
                        lineIndex: lineIndex,
                        positionIndex: positionIndex,
                        ballType: ballColors[lineIndex]
                    ))
                }
                
                // Add eggs at specified positions for this arm
                if eggPositionsForThisArm.contains(positionIndex) {
                    eggPositions.append(EggPosition(
                        lineIndex: lineIndex,
                        positionIndex: positionIndex,
                        isVisible: true,
                        isCollected: false
                    ))
                }
            }
        }
        
        updateVisibleBallsCount()
    }
    
    private func updateProgress() {
        let totalEggs = getTotalEggsForLevel()
        withAnimation(.easeInOut(duration: 0.5)) {
            progress = CGFloat(collectedEggs) / CGFloat(totalEggs)
        }
    }
    
    // ADD this method to track visible balls count
    private func updateVisibleBallsCount() {
        visibleBallsCount = ballPositions.filter { $0.isVisible }.count
    }
    
    private func updateHeaderEggPosition(from geometry: GeometryProxy) {
        let eggFrame = geometry.frame(in: .global)
        headerEggPosition = CGPoint(
            x: eggFrame.midX,
            y: eggFrame.midY
        )
        
        // Debug output
        print("Header Egg Position Updated: \(headerEggPosition)")
    }
    
    
    private func updateCircleLevelCenter(from geometry: GeometryProxy, in parentGeometry: GeometryProxy) {
        let circleFrame = geometry.frame(in: .global)
        circleLevelCenter = CGPoint(
            x: circleFrame.midX,
            y: circleFrame.midY
        )
    }
    
    private func eggAtPosition(lineIndex: Int, positionIndex: Int) -> EggPosition? {
        return eggPositions.first {
            $0.lineIndex == lineIndex &&
            $0.positionIndex == positionIndex &&
            !$0.isCollected
        }
    }
    
    
    private func ballAtPosition(lineIndex: Int, positionIndex: Int) -> BallPosition {
        // First try to find an existing ball
        if let existingBall = ballPositions.first(where: {
            $0.lineIndex == lineIndex && $0.positionIndex == positionIndex && $0.isVisible
        }) {
            return existingBall
        }
        
        // If no ball found at this position, return a dummy invisible ball
        return BallPosition(
            lineIndex: lineIndex,
            positionIndex: positionIndex,
            ballType: "red_ball",
            isVisible: false
        )
    }
    
    
    private func updateThrowBallPosition(from geometry: GeometryProxy) {
        let ballFrame = geometry.frame(in: .global)
        ballOrigin = CGPoint(x: ballFrame.minX, y: ballFrame.minY)
        throwBallPosition = CGPoint(
            x: ballFrame.midX + screenSize.width * 0.12,
            y: ballFrame.midY - screenSize.height * -0.02
        )
        
        if !isDrawingLine {
            lineStartPoint = throwBallPosition
            lineEndPoint = throwBallPosition
        }
    }
    
    private func resetLineDrawing() {
        withAnimation(.easeOut(duration: 0.3)) {
            lineEndPoint = throwBallPosition
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isDrawingLine = false
            currentTargetLine = nil
        }
    }
    
    private func changeBall() {
        guard !isChangingBall else { return }
        isChangingBall = true
        
        let currentIndex = basketBalls.firstIndex(of: currentThrowBall) ?? 0
        let nextIndex = (currentIndex + 1) % basketBalls.count
        let nextBall = basketBalls[nextIndex]
        
        let basketCenter = getBasketCenterPosition()
        
        flyingBall = nextBall
        flyingBallPosition = basketCenter
        flyingBallScale = 0.5
        
        withAnimation(.easeOut(duration: 0.6)) {
            flyingBallPosition = throwBallPosition
            flyingBallScale = 1.2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                flyingBallScale = 1.0
                currentThrowBall = nextBall
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                flyingBall = nil
                isChangingBall = false
            }
        }
    }
    
    private func getBasketCenterPosition() -> CGPoint {
        return CGPoint(
            x: screenSize.width - 80,
            y: screenSize.height - 100
        )
    }
    
    // UPDATED getTargetLine to include Three Columns level
    private func getTargetLine(from location: CGPoint) -> Int? {
        var targetLine: Int? = nil
        
        switch currentLevel {
        case 1: // NEW: Three Columns level - COLUMN TARGETING
            let totalColumns = 3
            let playAreaWidth = screenSize.width * 0.8
            let columnWidth = playAreaWidth / CGFloat(totalColumns)
            let startX = (screenSize.width - playAreaWidth) / 2
            
            for columnIndex in 0..<totalColumns {
                let columnXMin = startX + CGFloat(columnIndex) * columnWidth
                let columnXMax = startX + CGFloat(columnIndex + 1) * columnWidth
                
                if location.x >= columnXMin && location.x <= columnXMax {
                    targetLine = columnIndex
                    break
                }
            }
            
        case 2: // Triangle level - ROW-WISE TARGETING
            let totalRows = 3
            let playAreaHeight = screenSize.height * 0.4
            let rowHeight = playAreaHeight / CGFloat(totalRows)
            let startY = screenSize.height * 0.15 // Game area start
            
            // For triangle level, we detect which ROW the user is aiming at
            for rowIndex in 0..<totalRows {
                let rowYMin = startY + CGFloat(rowIndex) * rowHeight
                let rowYMax = startY + CGFloat(rowIndex + 1) * rowHeight
                
                // Check if location is within this row AND within reasonable X range
                let isInRow = location.y >= rowYMin && location.y <= rowYMax
                let isInValidXRange = location.x > screenSize.width * 0.1 && location.x < screenSize.width * 0.9
                
                if isInRow && isInValidXRange {
                    targetLine = rowIndex
                    break
                }
            }
            
        case 4: // Rectangle level - column-wise (existing)
            let totalLines = 6
            let playAreaWidth = screenSize.width * 0.8
            let columnWidth = playAreaWidth / CGFloat(totalLines)
            let startX = (screenSize.width - playAreaWidth) / 2
            
            for lineIndex in 0..<totalLines {
                let lineXMin = startX + CGFloat(lineIndex) * columnWidth
                let lineXMax = startX + CGFloat(lineIndex + 1) * columnWidth
                
                if location.x >= lineXMin && location.x <= lineXMax {
                    targetLine = lineIndex
                    break
                }
            }
            
        case 3, 5: // Hexagon and Circle levels - radial (existing)
            let center = circleLevelCenter
            let totalLines = 6
            let angle = atan2(location.y - center.y, location.x - center.x)
            var normalizedAngle = angle < 0 ? angle + 2 * .pi : angle
            
            normalizedAngle += .pi / 6
            if normalizedAngle >= 2 * .pi {
                normalizedAngle -= 2 * .pi
            }
            
            let lineIndex = Int(normalizedAngle / (2 * .pi / Double(totalLines))) % totalLines
            
            let distance = sqrt(pow(location.x - center.x, 2) + pow(location.y - center.y, 2))
            let minDistance: CGFloat = currentLevel == 3 ? 20 : 30
            let maxDistance: CGFloat = min(screenSize.width, screenSize.height) * (currentLevel == 3 ? 0.3 : 0.35)
            
            if distance >= minDistance && distance <= maxDistance {
                targetLine = lineIndex
            } else if distance < minDistance {
                showHitZoneHint = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showHitZoneHint = false
                }
                return nil
            }
        default:
            break
        }
        
        currentTargetLine = targetLine
        return targetLine
    }
    
    // UPDATE handleThrowRelease for Three Columns level
    private func handleThrowRelease(at location: CGPoint) {
        guard let targetLine = getTargetLine(from: location) else {
            if currentLevel == 3 || currentLevel == 5 {
                showToast(message: "Aim between the inner and outer circles!")
            } else if currentLevel == 1 {
                showToast(message: "Aim at one of the colored columns!")
            } else if currentLevel == 2 {
                showToast(message: "Aim at one of the colored rows!")
            } else {
                showToast(message: "Aim at one of the colored columns!")
            }
            currentTargetLine = nil
            return
        }
        
        let targetBallType = getBallTypeForLine(targetLine)
        
        if currentThrowBall != targetBallType {
            let colorName = targetBallType.replacingOccurrences(of: "_ball", with: "")
            let message: String
            if currentLevel == 2 {
                message = "Use \(colorName) ball for this row!"
            } else {
                message = "Use \(colorName) ball for this column!"
            }
            showToast(message: message)
            currentTargetLine = nil
            return
        }
        
        // Check if there are any balls left in this line
        let ballsInTargetLine = ballPositions.filter {
            $0.lineIndex == targetLine && $0.isVisible
        }
        
        if ballsInTargetLine.isEmpty {
            let message = currentLevel == 2 ? "No balls left in this row!" : "No balls left in this column!"
            showToast(message: message)
            currentTargetLine = nil
            return
        }
        
        animateBallThrowAndCollision(to: targetLine)
        currentTargetLine = nil
    }
    
    // UPDATE getLinearTargetPosition for Three Columns level
    private func getLinearTargetPosition(lineIndex: Int) -> CGPoint {
        switch currentLevel {
        case 1: // NEW: Three Columns - COLUMN targeting
            let totalColumns = 3
            let playAreaWidth = screenSize.width * 0.8
            let columnWidth = playAreaWidth / CGFloat(totalColumns)
            let startX = (screenSize.width - playAreaWidth) / 2
            
            // For three columns, target the center of the column
            let x = startX + CGFloat(lineIndex) * columnWidth + columnWidth / 2
            let y = screenSize.height * 0.3 // Middle of game area
            
            return CGPoint(x: x, y: y)
            
        case 2: // Triangle - ROW-WISE targeting
            let totalRows = 3
            let playAreaHeight = screenSize.height * 0.4
            let rowHeight = playAreaHeight / CGFloat(totalRows)
            let startY = screenSize.height * 0.15
            
            // For triangle, target the center of the row
            let y = startY + CGFloat(lineIndex) * rowHeight + rowHeight / 2
            let x = screenSize.width / 2 // Center of screen for row-wise
            
            return CGPoint(x: x, y: y)
            
        case 4: // Rectangle - column-wise (existing)
            let totalLines = 6
            let playAreaWidth = screenSize.width * 0.8
            let columnWidth = playAreaWidth / CGFloat(totalLines)
            let startX = (screenSize.width - playAreaWidth) / 2
            
            let x = startX + CGFloat(lineIndex) * columnWidth + columnWidth / 2
            let y = screenSize.height * 0.3
            
            return CGPoint(x: x, y: y)
            
        default:
            return CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.3)
        }
    }

    
    // UPDATE getBallTypeForLine to handle Three Columns level
    private func getBallTypeForLine(_ lineIndex: Int) -> String {
        let ballColors = ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"]
        
        // For Three Columns level
        if currentLevel == 1 {
            switch lineIndex {
            case 0: return "red_ball"
            case 1: return "green_ball"
            case 2: return "orange_ball"
            default: return "red_ball"
            }
        }
        
        // For triangle level, assign specific colors to rows
        if currentLevel == 2 {
            switch lineIndex {
            case 0: return "red_ball"
            case 1: return "blue_ball"
            case 2: return "yellow_ball"
            default: return "red_ball"
            }
        }
        
        return ballColors[lineIndex % ballColors.count]
    }
    
    
    private func animateBallThrowAndCollision(to targetLine: Int) {
        // Calculate target position based on level
        let targetPosition: CGPoint
        switch currentLevel {
        case 1, 2, 4: // Three Columns, Triangle and Rectangle levels
            targetPosition = getLinearTargetPosition(lineIndex: targetLine)
        case 3, 5: // Hexagon and Circle levels
            targetPosition = getCircularTargetPosition(lineIndex: targetLine)
        default:
            targetPosition = getLinearTargetPosition(lineIndex: targetLine)
        }
        
        flyingBall = currentThrowBall
        flyingBallPosition = throwBallPosition
        flyingBallScale = 1.0
        
        withAnimation(.easeOut(duration: 0.8)) {
            flyingBallPosition = targetPosition
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.animateBallCollision(lineIndex: targetLine)
            self.flyingBall = nil
        }
    }
    
    private func getCircularTargetPosition(lineIndex: Int) -> CGPoint {
        let center = circleLevelCenter
        let totalLines = 6
        let angle = Double(lineIndex) * (2 * .pi / Double(totalLines))
        let radius: CGFloat = min(screenSize.width, screenSize.height) * (currentLevel == 3 ? 0.08 : 0.1)
        let x = center.x + cos(angle) * radius
        let y = center.y + sin(angle) * radius
        return CGPoint(x: x, y: y)
    }
    
    
    private func createFlyingBallsAnimation(for balls: [BallPosition]) {
        for (index, ball) in balls.enumerated() {
            let startPosition = getBallScreenPosition(ball: ball)
            let targetY = screenSize.height + 100
            let randomMaxScale = CGFloat.random(in: 2.5...4.0)
            
            let flyingBall = FlyingBall(
                position: startPosition,
                targetPosition: CGPoint(x: startPosition.x, y: targetY),
                ballType: ball.ballType,
                scale: 1.0,
                maxScale: randomMaxScale,
                rotation: Double.random(in: -180...180),
                delay: Double(index) * 0.2
            )
            
            flyingBalls.append(flyingBall)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + flyingBall.delay) {
                
                withAnimation(.easeOut(duration: 1.5)) {
                    if let ballIndex = flyingBalls.firstIndex(where: { $0.id == flyingBall.id }) {
                        flyingBalls[ballIndex].scale = flyingBall.maxScale
                    }
                }
                
                withAnimation(.linear(duration: 1.5)) {
                    if let ballIndex = flyingBalls.firstIndex(where: { $0.id == flyingBall.id }) {
                        flyingBalls[ballIndex].rotation += Double.random(in: 180...360)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeIn(duration: 3.0)) {
                        if let ballIndex = flyingBalls.firstIndex(where: { $0.id == flyingBall.id }) {
                            flyingBalls[ballIndex].position = flyingBall.targetPosition
                        }
                    }
                    
                    withAnimation(.linear(duration: 3.0)) {
                        if let ballIndex = flyingBalls.firstIndex(where: { $0.id == flyingBall.id }) {
                            flyingBalls[ballIndex].rotation += Double.random(in: 180...360)
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 + 1.0) {
                        withAnimation(.easeOut(duration: 0.8)) {
                            if let ballIndex = flyingBalls.firstIndex(where: { $0.id == flyingBall.id }) {
                                flyingBalls[ballIndex].isVisible = false
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            flyingBalls.removeAll { $0.id == flyingBall.id }
                        }
                    }
                }
            }
        }
    }
    
    private func getBallScreenPosition(ball: BallPosition) -> CGPoint {
        switch currentLevel {
        case 1, 2, 4: // Three Columns, Triangle and Rectangle levels
            return CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.3)
        case 3, 5: // Hexagon and Circle levels
            let center = circleLevelCenter
            let totalLines = 6
            let angle = Double(ball.lineIndex) * (2 * .pi / Double(totalLines))
            let radius = CGFloat(ball.positionIndex) * min(screenSize.width, screenSize.height) * 0.05
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            
            return CGPoint(x: x, y: y)
        default:
            return CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.3)
        }
    }
    
    // MARK: - COMPLETELY REVISED showPointsToast with unique positions
    private func showPointsToast(egg: EggPosition, points: Int) {
        let eggPosition = getEggScreenPosition(egg: egg)
        
        // Create UNIQUE position for each toast
        let uniqueToastPosition = CGPoint(
            x: eggPosition.x + CGFloat(egg.positionIndex) * 30 - 30,
            y: eggPosition.y - 50 - CGFloat(egg.lineIndex) * 15
        )
        
        let pointsToast = PointsToast(
            position: uniqueToastPosition,
            text: "+\(points)"
        )
        
        pointsToasts.append(pointsToast)
        
        print("Showing points toast for egg \(egg.positionIndex) at position: \(uniqueToastPosition)")
        
        // Animate toast
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            if let index = pointsToasts.firstIndex(where: { $0.id == pointsToast.id }) {
                pointsToasts[index].scale = 1.3
            }
        }
        
        // Move toast upward and fade out
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 1.0)) {
                if let index = pointsToasts.firstIndex(where: { $0.id == pointsToast.id }) {
                    pointsToasts[index].position.y -= 100
                    pointsToasts[index].opacity = 0.0
                }
            }
            
            // Remove toast after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.pointsToasts.removeAll { $0.id == pointsToast.id }
            }
        }
    }
    
    private func showLevelCompleteWithConfetti() {
        // Create confetti
        createConfetti()
        
        // Show level complete overlay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showLevelComplete = true
        }
    }
    
    private func createConfetti() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
        
        for _ in 0..<50 {
            let randomX = CGFloat.random(in: 0...screenSize.width)
            let randomColor = colors.randomElement() ?? .red
            
            let confetti = ConfettiPiece(
                position: CGPoint(x: randomX, y: -20),
                color: randomColor,
                rotation: Double.random(in: 0...360),
                scale: CGFloat.random(in: 0.5...1.5)
            )
            
            confettiPieces.append(confetti)
            
            // Animate confetti falling
            withAnimation(.easeIn(duration: Double.random(in: 2.0...4.0))) {
                if let index = confettiPieces.firstIndex(where: { $0.id == confetti.id }) {
                    confettiPieces[index].position.y = screenSize.height + 50
                    confettiPieces[index].rotation += Double.random(in: 360...720)
                }
            }
            
            // Remove confetti after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                confettiPieces.removeAll { $0.id == confetti.id }
            }
        }
    }
    
    
    private func getEggScreenPosition(egg: EggPosition) -> CGPoint {
        switch currentLevel {
        case 1, 2, 4: // Three Columns, Triangle and Rectangle levels
            return CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.3)
        case 3, 5: // Hexagon and Circle levels
            let center = circleLevelCenter
            let totalLines = 6
            let angle = Double(egg.lineIndex) * (2 * .pi / Double(totalLines))
            let radius = CGFloat(egg.positionIndex) * min(screenSize.width, screenSize.height) * 0.05
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            
            return CGPoint(x: x, y: y)
        default:
            return CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.3)
        }
    }
    
    private func showToast(message: String) {
        toastMessage = message
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showToast = false
            }
        }
    }
}

// MARK: - Updated LevelCompleteView with Time Bonus
struct LevelCompleteView: View {
    let level: Int
    let onContinue: () -> Void
    
    private var levelName: String {
        switch level {
        case 1: return "Three Columns Level"
        case 2: return "Triangle Level"
        case 3: return "Hexagon Level"
        case 4: return "Rectangle Level"
        case 5: return "Circle Level"
        default: return "Level"
        }
    }
    
    private var nextLevelName: String {
        if level < 5 {
            switch level + 1 {
            case 2: return "Triangle Level"
            case 3: return "Hexagon Level"
            case 4: return "Rectangle Level"
            case 5: return "Circle Level"
            default: return "Next Level"
            }
        } else {
            return "Three Columns Level"
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Level \(level) Complete!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                
                Text(levelName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.yellow)
                
                if level < 5 {
                    Text("Great! Get ready for \(nextLevelName)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else {
                    Text("Amazing! You completed all levels!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button(action: onContinue) {
                    Text(level < 5 ? "Play Level \(level + 1)" : "See Results")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
            )
            .padding(20)
        }
    }
}

// MARK: - How to Play View
struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    
    let levels = [
        LevelInfo(
            levelNumber: 1,
            levelName: "Three Columns Level",
            description: "Match colored balls with their corresponding columns to release eggs from baskets",
            themeImage: "three_columns_theme",
            ballType: "red_ball",
            tips: [
                "Drag the ball upward to draw a throwing line",
                "Aim at the colored columns matching your ball color",
                "Collect eggs released from baskets when balls hit"
            ]
        ),
        LevelInfo(
            levelNumber: 2,
            levelName: "Triangle Level",
            description: "Target specific rows in triangular formation to collect hidden eggs",
            themeImage: "triangle_theme",
            ballType: "blue_ball",
            tips: [
                "Each row requires a specific colored ball",
                "Red balls for top row, blue for middle, yellow for bottom",
                "Eggs are hidden behind balls - clear the path to collect them"
            ]
        ),
        LevelInfo(
            levelNumber: 3,
            levelName: "Hexagon Level",
            description: "Navigate the hexagonal pattern by aiming between inner and outer circles",
            themeImage: "hexagon_theme",
            ballType: "green_ball",
            tips: [
                "Aim between the inner and outer circles",
                "Six colored arms with strategic egg placements",
                "Clear balls to reveal and collect hidden eggs"
            ]
        ),
        LevelInfo(
            levelNumber: 4,
            levelName: "Rectangle Level",
            description: "Master the grid layout with strategic egg placements in rectangular formation",
            themeImage: "rectangle_theme",
            ballType: "purple_ball",
            tips: [
                "Clear balls from columns to reveal hidden eggs",
                "Each column corresponds to a specific ball color",
                "Strategic planning required for optimal egg collection"
            ]
        ),
        LevelInfo(
            levelNumber: 5,
            levelName: "Circle Level",
            description: "Master the circular layout with multiple egg collection points in radial pattern",
            themeImage: "circle_theme",
            ballType: "orange_ball",
            tips: [
                "Most challenging level with complex patterns",
                "Multiple eggs per arm to collect",
                "Strategic ball throwing required for success",
                "Aim precisely between concentric circles"
            ]
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            GeometryReader { geometry in
                Image("game_background_level1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(Color.black.opacity(0.5))
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                ZStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(15)
                        }
                        
                        Spacer()
                        
                        Text("Game Help")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                        
                        Spacer()
                        
                        // Empty space for balance
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 80, height: 40)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                // Page Content
                TabView(selection: $currentPage) {
                    // Welcome Page
                    WelcomePageView()
                        .tag(-1)
                    
                    // Level Pages - NOW 5 PAGES
                    ForEach(0..<levels.count, id: \.self) { index in
                        LevelTutorialView(levelInfo: levels[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Page Indicators and Navigation
                VStack(spacing: 15) {
                    // Page Indicators - NOW 6 (Welcome + 5 Levels)
                    HStack(spacing: 8) {
                        ForEach(-1..<levels.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.orange : Color.white.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    // Navigation Buttons
                    HStack(spacing: 20) {
                        if currentPage > -1 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("Previous")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(20)
                            }
                        }
                        
                        Spacer()
                        
                        if currentPage < levels.count - 1 {
                            Button(action: {
                                withAnimation {
                                    currentPage += 1
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Text(currentPage == -1 ? "Get Started" : "Next")
                                        .font(.system(size: 16, weight: .semibold))
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.green.opacity(0.8))
                                .cornerRadius(20)
                            }
                        } else {
                            Button(action: {
                                dismiss()
                            }) {
                                HStack(spacing: 8) {
                                    Text("Back to Menu")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: [Color.orange, Color.red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 30)
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Updated Level Preview View with All 5 Levels
struct LevelPreviewView: View {
    let levelInfo: LevelInfo
    
    var body: some View {
        ZStack {
            switch levelInfo.levelNumber {
            case 1:
                // Three Columns Preview with Balls and Eggs
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { column in
                        VStack(spacing: 8) {
                            // Basket with Eggs
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.brown)
                                    .frame(width: 40, height: 25)
                                
                                // Eggs in basket
                                HStack(spacing: 2) {
                                    ForEach(0..<(column + 2), id: \.self) { _ in
                                        Image("egg_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                    }
                                }
                            }
                            
                            // Balls in column
                            VStack(spacing: 4) {
                                ForEach(0..<3, id: \.self) { _ in
                                    GlowingGlassBall(ballType: getColumnColor(column), size: 18)
                                }
                            }
                        }
                    }
                }
                
            case 2:
                // Triangle Preview with Balls and Eggs
                VStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 6) {
                            ForEach(0..<(3 - row), id: \.self) { position in
                                ZStack {
                                    // Show egg behind ball at specific positions
                                    if (row == 0 && position == 0) ||
                                       (row == 1 && position == 0) ||
                                       (row == 2 && position == 0) {
                                        Image("egg_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                            .offset(x: -2, y: -2)
                                    }
                                    
                                    GlowingGlassBall(
                                        ballType: getTriangleColor(row),
                                        size: 18
                                    )
                                }
                            }
                        }
                    }
                }
                
            case 3:
                // Hexagon Preview with Balls and Eggs
                ZStack {
                    HexagonShape()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .frame(width: 100, height: 100)
                    
                    ForEach(0..<6, id: \.self) { i in
                        let angle = Double(i) * (2 * .pi / 6)
                        
                        // Inner circle balls
                        let innerX = cos(angle) * 20
                        let innerY = sin(angle) * 20
                        
                        // Outer circle balls and eggs
                        let outerX = cos(angle) * 40
                        let outerY = sin(angle) * 40
                        
                        // Middle position for eggs
                        let middleX = cos(angle) * 30
                        let middleY = sin(angle) * 30
                        
                        // Inner balls
                        GlowingGlassBall(ballType: getHexagonColor(i), size: 12)
                            .offset(x: CGFloat(innerX), y: CGFloat(innerY))
                        
                        // Outer balls
                        GlowingGlassBall(ballType: getHexagonColor(i), size: 12)
                            .offset(x: CGFloat(outerX), y: CGFloat(outerY))
                        
                        // Eggs at middle positions on specific arms
                        if i == 1 || i == 3 || i == 5 {
                            Image("egg_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .offset(x: CGFloat(middleX), y: CGFloat(middleY))
                        }
                    }
                }
                
            case 4:
                // Rectangle Level Preview with Balls and Eggs
                VStack(spacing: 4) {
                    ForEach(0..<6, id: \.self) { row in
                        HStack(spacing: 4) {
                            ForEach(0..<6, id: \.self) { column in
                                ZStack {
                                    // Add eggs at specific positions in the grid
                                    if (row == 0 && column == 2) ||
                                       (row == 1 && column == 0) ||
                                       (row == 2 && column == 4) ||
                                       (row == 3 && column == 1) ||
                                       (row == 4 && column == 3) ||
                                       (row == 5 && column == 4) {
                                        Image("egg_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                            .zIndex(1)
                                    }
                                    
                                    // Add balls at other positions
                                    if !((row == 0 && column == 2) ||
                                       (row == 1 && column == 0) ||
                                       (row == 2 && column == 4) ||
                                       (row == 3 && column == 1) ||
                                       (row == 4 && column == 3) ||
                                       (row == 5 && column == 4)) {
                                        GlowingGlassBall(ballType: getRectangleColor(row), size: 10)
                                    }
                                }
                                .frame(width: 12, height: 12)
                            }
                        }
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                
            case 5:
                // Circle Level Preview with Balls and Eggs
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .frame(width: 100, height: 100)
                    
                    ForEach(0..<6, id: \.self) { i in
                        let angle = Double(i) * (2 * .pi / 6)
                        
                        // Multiple concentric circles for balls and eggs
                        ForEach(1..<4, id: \.self) { radiusIndex in
                            let radius = CGFloat(radiusIndex) * 15
                            let x = cos(angle) * radius
                            let y = sin(angle) * radius
                            
                            // Add balls at most positions
                            if !(radiusIndex == 3 && (i == 1 || i == 3 || i == 5)) {
                                GlowingGlassBall(ballType: getCircleColor(i), size: 10)
                                    .offset(x: CGFloat(x), y: CGFloat(y))
                            }
                            
                            // Add eggs at strategic positions
                            if (radiusIndex == 3 && (i == 1 || i == 3 || i == 5)) ||
                               (radiusIndex == 2 && (i == 0 || i == 2 || i == 4)) {
                                Image("egg_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .offset(x: CGFloat(x), y: CGFloat(y))
                            }
                        }
                    }
                }
                
            default:
                Rectangle()
                    .fill(Color.clear)
            }
        }
    }
    
    private func getColumnColor(_ column: Int) -> String {
        switch column {
        case 0: return "red_ball"
        case 1: return "green_ball"
        case 2: return "orange_ball"
        default: return "red_ball"
        }
    }
    
    private func getTriangleColor(_ row: Int) -> String {
        switch row {
        case 0: return "red_ball"
        case 1: return "blue_ball"
        case 2: return "yellow_ball"
        default: return "red_ball"
        }
    }
    
    private func getHexagonColor(_ index: Int) -> String {
        let colors = ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"]
        return colors[index % colors.count]
    }
    
    private func getRectangleColor(_ row: Int) -> String {
        let colors = ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"]
        return colors[row % colors.count]
    }
    
    private func getCircleColor(_ index: Int) -> String {
        let colors = ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"]
        return colors[index % colors.count]
    }
}

// MARK: - Updated LevelTutorialView for All 5 Levels
struct LevelTutorialView: View {
    let levelInfo: LevelInfo
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Level Header
                VStack(spacing: 8) {
                    Text("Level \(levelInfo.levelNumber)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                    
                    Text(levelInfo.levelName)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(levelInfo.description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                // Enhanced Level Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                    
                    VStack(spacing: 20) {
                        // Level-specific graphic with balls and eggs
                        LevelPreviewView(levelInfo: levelInfo)
                            .frame(height: 120)
                        
                        // Game Elements Legend
                        HStack(spacing: 20) {
                            VStack(spacing: 5) {
                                GlowingGlassBall(ballType: levelInfo.ballType, size: 24)
                                Text("Balls")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            VStack(spacing: 5) {
                                Image("egg_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Eggs")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            if levelInfo.levelNumber == 1 {
                                VStack(spacing: 5) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.brown)
                                        .frame(width: 24, height: 18)
                                    Text("Baskets")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                    }
                    .padding(20)
                }
                .frame(height: 200)
                .padding(.horizontal, 20)
                
                // Tips Section
                VStack(spacing: 15) {
                    Text("Pro Tips")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                    
                    VStack(spacing: 12) {
                        ForEach(Array(levelInfo.tips.enumerated()), id: \.offset) { index, tip in
                            LevelTipView(number: index + 1, text: tip)
                        }
                    }
                    .padding(.horizontal, 10)
                }
                
                // Strategy Guide
                VStack(spacing: 15) {
                    Text("Strategy Guide")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        StrategyPointView(
                            icon: "eye.fill",
                            text: getStrategyHint(for: levelInfo.levelNumber)
                        )
                        
                        StrategyPointView(
                            icon: "target",
                            text: getTargetingHint(for: levelInfo.levelNumber)
                        )
                        
                        StrategyPointView(
                            icon: "star.fill",
                            text: getCollectionHint(for: levelInfo.levelNumber)
                        )
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
        }
    }
    
    private func getStrategyHint(for level: Int) -> String {
        switch level {
        case 1: return "Clear balls from bottom to top to release eggs from baskets"
        case 2: return "Target specific rows - red for top, blue for middle, yellow for bottom"
        case 3: return "Aim between inner and outer circles to hit the hexagon arms"
        case 4: return "Clear balls from columns strategically to reveal hidden eggs"
        case 5: return "Master the radial pattern - aim precisely between concentric circles"
        default: return "Master the pattern to collect all eggs efficiently"
        }
    }
    
    private func getTargetingHint(for level: Int) -> String {
        switch level {
        case 1: return "Match ball color with column color for successful hits"
        case 2: return "Each row requires its specific colored ball"
        case 3: return "Use the throwing line to aim precisely between circles"
        case 4: return "Columns correspond to different ball colors in the grid"
        case 5: return "Radial targeting - each arm has its specific color"
        default: return "Color matching is key to breaking balls"
        }
    }
    
    private func getCollectionHint(for level: Int) -> String {
        switch level {
        case 1: return "Baskets hold eggs - clear all balls in a column to empty its basket"
        case 2: return "Eggs are hidden behind balls - clear the path to collect them"
        case 3: return "Eggs are placed strategically along the hexagon arms"
        case 4: return "Eggs are hidden within the rectangular grid pattern"
        case 5: return "Multiple eggs per arm to collect in circular formation"
        default: return "Collect all eggs to complete the level"
        }
    }
}


// MARK: - New Strategy Point View
struct StrategyPointView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.yellow)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

// MARK: - Level Info Model
struct LevelInfo {
    let levelNumber: Int
    let levelName: String
    let description: String
    let themeImage: String
    let ballType: String
    let tips: [String]
}

// MARK: - Welcome Page View
struct WelcomePageView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Title
                VStack(spacing: 10) {
                    Text("Chicken Bubble Blitz")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Master the Art of Egg Collection!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.yellow)
                        .multilineTextAlignment(.center)
                }
                
                // Main Characters
                HStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Image("chicken")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        Text("Chicken Helper")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 10) {
                        Image("basket")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        Text("Egg Basket")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Game Overview
                VStack(spacing: 20) {
                    Text("Game Overview")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        GameFeatureView(
                            icon: "hand.draw.fill",
                            title: "Drag & Throw",
                            description: "Drag the ball upward to draw a throwing line and release to throw"
                        )
                        
                        GameFeatureView(
                            icon: "target",
                            title: "Color Matching",
                            description: "Match ball colors with target columns/rows for successful hits"
                        )
                        
                        GameFeatureView(
                            icon: "egg.fill",
                            title: "Egg Collection",
                            description: "Collect eggs that appear when you clear balls from their paths"
                        )
                        
                        GameFeatureView(
                            icon: "arrow.clockwise",
                            title: "Ball Switching",
                            description: "Tap the basket to switch between different colored balls"
                        )
                    }
                    .padding(.horizontal, 20)
                }
                
                // Quick Tips
                VStack(spacing: 15) {
                    Text("Quick Tips")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        TipView(text: "Aim carefully - wrong colors won't break balls")
                        TipView(text: "Collect all eggs to complete each level")
                        TipView(text: "Use the ball change feature strategically")
                        TipView(text: "Watch for the throwing line guidance")
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}


// MARK: - Supporting Views
struct GameFeatureView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

struct TipView: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 14))
                .foregroundColor(.yellow)
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

struct LevelTipView: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.orange))
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

struct GameElementView: View {
    let icon: String
    let name: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            
            Text(name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}


struct MainGameMenuView: View {
    @State private var isShowingGame = false
    @State private var isShowingHowToPlay = false
    @State private var isShowingLevelSelection = false // ADD THIS
    @StateObject private var soundManager = SoundManager.shared
    
    @State private var playButtonScale: CGFloat = 1.0
    @State private var howToPlayButtonScale: CGFloat = 1.0
    @State private var levelButtonScale: CGFloat = 1.0 // ADD THIS
    @State private var playButtonGlow = false
    @State private var howToPlayButtonGlow = false
    @State private var levelButtonGlow = false // ADD THIS
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with image
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text("ChickenEggs\nBubbleBlitz")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .red, radius: 10, x: -2, y: 0)
                        .shadow(color: .green, radius: 10, x: 2, y: 0)
                        .shadow(color: .white.opacity(0.8), radius: 5, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                        .padding(.top, 8)
                       
                    
                    VStack(spacing: 12){
                        // CHANGED TO VSTACK FOR 3 BUTTONS
                        HStack(spacing: 40) {
                            // Play Button
                            Button(action: {
                                isShowingGame = true
                            }) {
                                MenuCircleButton(
                                    icon: "play.fill",
                                    iconOffset: 4,
                                    scale: playButtonScale,
                                    glow: playButtonGlow,
                                    colors: [Color.green, Color(red: 0.1, green: 0.6, blue: 0.1)]
                                )
                            }
                            
                            // Level Selection Button - NEW
                            Button(action: {
                                isShowingLevelSelection = true
                            }) {
                                MenuCircleButton(
                                    icon: "list.number",
                                    iconOffset: 0,
                                    scale: levelButtonScale,
                                    glow: levelButtonGlow,
                                    colors: [Color.blue, Color.purple]
                                )
                            }
                            
                        }
                    
                        
                        // Bottom Menu Buttons
                        HStack(spacing: 30) {
                            // How to Play Button
                            Button(action: {
                                isShowingHowToPlay = true
                            }) {
                                MenuCircleButton(
                                    icon: "questionmark",
                                    iconOffset: 0,
                                    scale: howToPlayButtonScale,
                                    glow: howToPlayButtonGlow,
                                    colors: [Color.orange, Color.red]
                                )
                            }
                            
                            // Skillz Button - NEW
                            Button(action: {
                                Skillz.skillzInstance().launch()
                            }) {
                                MenuCircleButton(
                                    icon: "s.circle.fill",
                                    iconOffset: 0,
                                    scale: 1.0,
                                    glow: true,
                                    colors: [Color.red, Color.black]
                                )
                                .overlay(
                                    Text("SKILLZ")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(.white)
                                        .offset(y: 35)
                                )
                            }
                        }
                    }
                
                    Image("chicken")
                        .resizable()
                        .frame(width: 220,height: 220)
                        .padding(.bottom, 20)
                    
        
                }
                .padding(.horizontal, 16)
            }
            .onAppear {
                // Start blinking animation for play button
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    playButtonScale = 1.1
                    playButtonGlow.toggle()
                }
                
                // Start blinking animation for level button with delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        levelButtonScale = 1.1
                        levelButtonGlow.toggle()
                    }
                }
                
                // Start blinking animation for how-to-play button with delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        howToPlayButtonScale = 1.1
                        howToPlayButtonGlow.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingGame) {
                MainGameView()
            }
            .fullScreenCover(isPresented: $isShowingHowToPlay) {
                HowToPlayView()
            }
            .fullScreenCover(isPresented: $isShowingLevelSelection) {
                LevelSelectionView()
            }
        }
        .environmentObject(soundManager)
    }
}

// MARK: - Reusable Menu Circle Button Component
struct MenuCircleButton: View {
    let icon: String
    let iconOffset: CGFloat
    let scale: CGFloat
    let glow: Bool
    let colors: [Color]
    
    var body: some View {
        ZStack {
            // Outer Glow Circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            colors.first?.opacity(0.8) ?? Color.green.opacity(0.8),
                            colors.first?.opacity(0.4) ?? Color.green.opacity(0.4),
                            colors.first?.opacity(0.2) ?? Color.green.opacity(0.2),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .scaleEffect(glow ? 1.2 : 0.9)
                .opacity(glow ? 1.0 : 0.7)
            
            // Main Button Circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 6) // WHITE BOLD BORDER
                )
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                .scaleEffect(scale)
            
            // Icon
            Image(systemName: icon)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                .offset(x: iconOffset)
        }
        .frame(width: 120, height: 120)
    }
}
// NEW: Reusable Menu Button Component
struct MenuButtonView: View {
    let title: String
    let subtitle: String
    let icon: String
    let scale: CGFloat
    let glow: Bool
    let colors: [Color]
    
    var body: some View {
        ZStack {
            // Outer Glow Effect
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            colors.first?.opacity(0.8) ?? .blue.opacity(0.8),
                            colors.first?.opacity(0.4) ?? .blue.opacity(0.4),
                            colors.first?.opacity(0.2) ?? .blue.opacity(0.2),
                            .clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .scaleEffect(glow ? 1.15 : 0.9)
                .opacity(glow ? 1.0 : 0.7)
            
            // Main Button Container
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 300, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                .scaleEffect(scale)
            
            // Content
            HStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                }
                
                // Text Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Chevron Icon
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(0.8)
            }
            .padding(.horizontal, 25)
        }
        .frame(width: 320, height: 100)
    }
}

// MARK: - Updated Main Game View with Level Parameter
struct MainGameViewWithLevel: View {
    let startingLevel: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        MainGameViewWrapper(startingLevel: startingLevel)
    }
}

struct MainGameViewWrapper: View {
    let startingLevel: Int
    @State private var currentLevel: Int = 1
    
    var body: some View {
        MainGameView()
            .onAppear {
                currentLevel = startingLevel
            }
    }
}




// MARK: - Level Card Info Model
struct LevelCardInfo: Identifiable {
    let id = UUID()
    let levelNumber: Int
    let levelName: String
    let description: String
    let themeColor: Color
    let themeImage: String
    let ballTypes: [String]
    let difficulty: String
    let timeLimit: String
    let totalEggs: Int
}


// MARK: - Level Selection View
struct LevelSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLevel: Int? = nil
    @State private var isStartingGame = false
    
    let levels = [
        LevelCardInfo(
            levelNumber: 1,
            levelName: "Column Crush",
            description: "Match colors to clear columns and release eggs from baskets",
            themeColor: Color.red,
            themeImage: "three_columns_theme",
            ballTypes: ["red_ball", "green_ball", "orange_ball"],
            difficulty: "Easy",
            timeLimit: "1:30 min",
            totalEggs: 9
        ),
        LevelCardInfo(
            levelNumber: 2,
            levelName: "Triangle Tangle",
            description: "Navigate the triangular maze to uncover hidden eggs",
            themeColor: Color.blue,
            themeImage: "triangle_theme",
            ballTypes: ["red_ball", "blue_ball", "yellow_ball"],
            difficulty: "Easy",
            timeLimit: "2:00 min",
            totalEggs: 6
        ),
        LevelCardInfo(
            levelNumber: 3,
            levelName: "Hexagon Hustle",
            description: "Master the hexagon pattern with precise radial throws",
            themeColor: Color.green,
            themeImage: "hexagon_theme",
            ballTypes: ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"],
            difficulty: "Medium",
            timeLimit: "2:30 min",
            totalEggs: 6
        ),
        LevelCardInfo(
            levelNumber: 4,
            levelName: "Rectangle Riddle",
            description: "Solve the grid puzzle with strategic color matching",
            themeColor: Color.purple,
            themeImage: "rectangle_theme",
            ballTypes: ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"],
            difficulty: "Medium",
            timeLimit: "3:00 min",
            totalEggs: 6
        ),
        LevelCardInfo(
            levelNumber: 5,
            levelName: "Circle Challenge",
            description: "Conquer the circular arena in this ultimate egg hunt",
            themeColor: Color.orange,
            themeImage: "circle_theme",
            ballTypes: ["red_ball", "blue_ball", "yellow_ball", "green_ball", "purple_ball", "orange_ball"],
            difficulty: "Hard",
            timeLimit: "3:30 min",
            totalEggs: 12
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                GeometryReader { geometry in
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    ZStack {
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("Back")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                            }
                        
                            
                            Text("Level Menu")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    // Levels Grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 25) {
                            ForEach(levels) { level in
                                LevelCardView(levelInfo: level)
                                    .padding(.horizontal, 12)
                                    .onTapGesture {
                                        selectedLevel = level.levelNumber
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            isStartingGame = true
                                        }
                                    }
                                    .scaleEffect(selectedLevel == level.levelNumber ? 0.98 : 1.0)
                                    .animation(.spring(response: 0.3), value: selectedLevel)
                            }
                        }
    
                        .padding(.bottom, 30)
                        .padding(.top, 16)
                    }
                }
                
            }
            
            .fullScreenCover(isPresented: $isStartingGame) {
                if let level = selectedLevel {
                    MainGameView(startingLevel: level)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Level Card View (UPDATED)
struct LevelCardView: View {
    let levelInfo: LevelCardInfo
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Card Background with Gradient
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [
                            levelInfo.themeColor.opacity(0.8),
                            levelInfo.themeColor.opacity(0.5),
                            levelInfo.themeColor.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.5), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: levelInfo.themeColor.opacity(0.4), radius: 15, x: 0, y: 5)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            // Card Content
            HStack(spacing: 15) {
                // Left Side - Level Number and Preview
                VStack(spacing: 10) {
                    // Level Badge
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        Text("\(levelInfo.levelNumber)")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundColor(levelInfo.themeColor)
                    }
                    
                    // Mini Level Preview
                    MiniLevelPreview(levelNumber: levelInfo.levelNumber, ballTypes: levelInfo.ballTypes)
                        .frame(height: 50)
                }
                .frame(width: 80)
                
                // Middle - Level Details
                VStack(alignment: .leading, spacing: 6) {
                    // Level Name
                    Text(levelInfo.levelName)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    
                    // Description
                    Text(levelInfo.description)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Stats Row
                    HStack(spacing: 2) {
                        StatBadgeView(
                            icon: "speedometer",
                            value: levelInfo.difficulty,
                            label: "Difficulty",
                            color: .white
                        )
                        
                        StatBadgeView(
                            icon: "clock.fill",
                            value: levelInfo.timeLimit,
                            label: "Time",
                            color: .white
                        )
                        
                        StatBadgeView(
                            icon: "egg.fill",
                            value: "\(levelInfo.totalEggs)",
                            label: "Eggs",
                            color: .yellow
                        )
                    }
                    .padding(.top, 4)
                    
                    // Ball Types
                    HStack(spacing: 5) {
                        Text("Balls:")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                        
                        ForEach(levelInfo.ballTypes.prefix(4), id: \.self) { ballType in
                            GlowingGlassBall(ballType: ballType, size: 18)
                                .frame(width: 18, height: 18)
                        }
                        
                        if levelInfo.ballTypes.count > 4 {
                            Text("+\(levelInfo.ballTypes.count - 4)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(6)
                        }
                    }
                    .padding(.top, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Play Button Arrow
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .opacity(0.9)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    .padding(.trailing, 5)
            }
            .padding(20)
        }
        .frame(height: 160)
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Stat Badge View (UPDATED)
struct StatBadgeView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 9))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
            }
            
            Text(label)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(color.opacity(0.8))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.white.opacity(0.15))
        .cornerRadius(6)
        .frame(minWidth: 60)
    }
}

// MARK: - Mini Level Preview Component (UPDATED)
struct MiniLevelPreview: View {
    let levelNumber: Int
    let ballTypes: [String]
    
    var body: some View {
        ZStack {
            switch levelNumber {
            case 1:
                // Three Columns Preview
                HStack(spacing: 5) {
                    ForEach(0..<3, id: \.self) { column in
                        VStack(spacing: 2) {
                            ForEach(0..<2, id: \.self) { _ in
                                GlowingGlassBall(
                                    ballType: ballTypes[min(column, ballTypes.count - 1)],
                                    size: 10
                                )
                                .frame(width: 10, height: 10)
                            }
                        }
                    }
                }
                
            case 2:
                // Triangle Preview
                VStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 3) {
                            ForEach(0..<(3 - row), id: \.self) { _ in
                                GlowingGlassBall(
                                    ballType: ballTypes[min(row, ballTypes.count - 1)],
                                    size: 8
                                )
                                .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
                
            case 3:
                // Hexagon Preview
                ZStack {
                    HexagonShape()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: 40, height: 40)
                    
                    ForEach(0..<3, id: \.self) { i in
                        let angle = Double(i) * (2 * .pi / 3)
                        let x = cos(angle) * 12
                        let y = sin(angle) * 12
                        
                        GlowingGlassBall(
                            ballType: ballTypes[i % ballTypes.count],
                            size: 8
                        )
                        .frame(width: 8, height: 8)
                        .offset(x: CGFloat(x), y: CGFloat(y))
                    }
                }
                
            case 4:
                // Rectangle Preview
                VStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 2) {
                            ForEach(0..<3, id: \.self) { col in
                                GlowingGlassBall(
                                    ballType: ballTypes[row % ballTypes.count],
                                    size: 7
                                )
                                .frame(width: 7, height: 7)
                            }
                        }
                    }
                }
                
            case 5:
                // Circle Preview
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: 40, height: 40)
                    
                    ForEach(0..<6, id: \.self) { i in
                        let angle = Double(i) * (2 * .pi / 6)
                        let x = cos(angle) * 15
                        let y = sin(angle) * 15
                        
                        GlowingGlassBall(
                            ballType: ballTypes[i % ballTypes.count],
                            size: 7
                        )
                        .frame(width: 7, height: 7)
                        .offset(x: CGFloat(x), y: CGFloat(y))
                    }
                }
                
            default:
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 30, height: 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


// MARK: - Game Models
struct BallPosition: Identifiable {
    let id = UUID()
    let lineIndex: Int
    let positionIndex: Int
    let ballType: String
    var isVisible: Bool = true
}


// MARK: - UPDATE FlyingEgg struct to include target position
struct FlyingEgg: Identifiable {
    let id = UUID()
    var position: CGPoint
    var scale: CGFloat = 2.0 // LARGER DEFAULT SIZE
    var isVisible: Bool = true
    var targetPosition: CGPoint = .zero // ADD THIS
}


struct EggPosition: Identifiable {
    let id = UUID()
    let lineIndex: Int
    let positionIndex: Int
    var isVisible: Bool = true
    var isCollected: Bool = false
}

struct FlyingBall: Identifiable {
    let id = UUID()
    var position: CGPoint
    var targetPosition: CGPoint
    var ballType: String
    var scale: CGFloat = 1.0
    var maxScale: CGFloat = 3.0
    var rotation: Double = 0
    var isVisible: Bool = true
    var delay: Double = 0
}

// MARK: - UPDATE PointsToast struct
struct PointsToast: Identifiable {
    let id = UUID()
    var position: CGPoint
    var text: String
    var scale: CGFloat = 1.0
    var opacity: Double = 1.0
    var isVisible: Bool = true
}




struct ConfettiPiece: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var rotation: Double = 0
    var scale: CGFloat = 1.0
    var isVisible: Bool = true
}

// MARK: - NEW: Basket with Eggs Model
struct BasketWithEggs: Identifiable {
    let id = UUID()
    let columnIndex: Int
    let ballType: String
    var eggs: Int
    var maxEggs: Int
    var position: CGPoint = .zero
}

// MARK: - Custom Glowing Glass Balls

struct GlowingGlassBall: View {
    let ballType: String
    let size: CGFloat
    @State private var glowAnimation = false
    
    private var gradientColors: [Color] {
        switch ballType {
        case "red_ball":
            return [Color(red: 1.0, green: 0.3, blue: 0.3), Color(red: 1.0, green: 0.1, blue: 0.1), Color(red: 0.8, green: 0.0, blue: 0.0)]
        case "blue_ball":
            return [Color(red: 0.3, green: 0.5, blue: 1.0), Color(red: 0.1, green: 0.3, blue: 1.0), Color(red: 0.0, green: 0.1, blue: 0.8)]
        case "yellow_ball":
            return [Color(red: 1.0, green: 0.9, blue: 0.3), Color(red: 1.0, green: 0.8, blue: 0.1), Color(red: 0.9, green: 0.7, blue: 0.0)]
        case "green_ball":
            return [Color(red: 0.3, green: 0.9, blue: 0.3), Color(red: 0.1, green: 0.8, blue: 0.1), Color(red: 0.0, green: 0.7, blue: 0.0)]
        case "purple_ball":
            return [Color(red: 0.8, green: 0.3, blue: 1.0), Color(red: 0.7, green: 0.1, blue: 0.9), Color(red: 0.6, green: 0.0, blue: 0.8)]
        case "orange_ball":
            return [Color(red: 1.0, green: 0.6, blue: 0.3), Color(red: 1.0, green: 0.5, blue: 0.1), Color(red: 0.9, green: 0.4, blue: 0.0)]
        default:
            return [Color.white, Color.gray, Color.black]
        }
    }
    
    private var glowColor: Color {
        switch ballType {
        case "red_ball": return Color.red.opacity(0.6)
        case "blue_ball": return Color.blue.opacity(0.6)
        case "yellow_ball": return Color.yellow.opacity(0.6)
        case "green_ball": return Color.green.opacity(0.6)
        case "purple_ball": return Color.purple.opacity(0.6)
        case "orange_ball": return Color.orange.opacity(0.6)
        default: return Color.white.opacity(0.6)
        }
    }
    
    var body: some View {
        ZStack {
            // Outer Glow
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [glowColor, glowColor.opacity(0.1), .clear]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.8
                    )
                )
                .scaleEffect(glowAnimation ? 1.2 : 0.9)
                .opacity(glowAnimation ? 0.8 : 0.4)
            
            // Main Glass Ball
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: gradientColors),
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.8), .clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: glowColor, radius: glowAnimation ? 15 : 8, x: 0, y: 0)
            
            // Glass Reflection
            Circle()
                .trim(from: 0.3, to: 0.5)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.white.opacity(0.9), .white.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round)
                )
                .frame(width: size * 0.6, height: size * 0.6)
                .rotationEffect(.degrees(-45))
                .offset(x: -size * 0.15, y: -size * 0.15)
            
            // Inner Sparkle
            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: size * 0.2, height: size * 0.2)
                .blur(radius: 2)
                .offset(x: -size * 0.2, y: -size * 0.2)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowAnimation.toggle()
            }
        }
    }
}

struct FlyingGlowingBall: View {
    let ballType: String
    let size: CGFloat
    var scale: CGFloat = 1.0
    var rotation: Double = 0
    
    var body: some View {
        GlowingGlassBall(ballType: ballType, size: size)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
    }
}

// MARK: - Blinking Animation Modifier
struct BlinkingModifier: ViewModifier {
    @State private var isBlinking = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isBlinking ? 0.3 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    isBlinking = true
                }
            }
    }
}

extension View {
    func blinking() -> some View {
        self.modifier(BlinkingModifier())
    }
}

// MARK: - NEW: Basket with Eggs View
struct BasketWithEggsView: View {
    let basket: BasketWithEggs
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: 4) {
            // Basket
            ZStack {
                // Basket Back Side
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color.brown.opacity(0.6), Color.brown.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size * 0.8, height: size * 0.5)
                    .offset(y: 3)
                
                // Basket Front Side
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.8, green: 0.6, blue: 0.4),
                                Color(red: 0.7, green: 0.5, blue: 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size, height: size * 0.6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.brown.opacity(0.8), lineWidth: 2)
                    )
                
                // Basket Handle
                Capsule()
                    .fill(Color.brown)
                    .frame(width: size * 0.6, height: 4)
                    .offset(y: -size * 0.4)
            }
            
            // Eggs in basket
            HStack(spacing: 2) {
                ForEach(0..<basket.eggs, id: \.self) { _ in
                    Image("egg_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.2, height: size * 0.2)
                }
            }
            
            // Egg count
            Text("\(basket.eggs)/\(basket.maxEggs)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        // Update basket position for egg collection animation
                        // This would be handled in the parent view
                    }
                
            
            }
        )
    }
}

// MARK: - UPDATED: Three Columns Level View
struct ThreeColumnsLevelView: View {
    let ballPositions: [BallPosition]
    let eggPositions: [EggPosition]
    let baskets: [BasketWithEggs]
    let disappearingBalls: [UUID]
    let eggAtPosition: (Int, Int) -> EggPosition?
    let ballAtPosition: (Int, Int) -> BallPosition
    
    var body: some View {
        GeometryReader { geometry in
            let containerHeight = geometry.size.height
            let itemSize = containerHeight / 10 // Slightly larger for better visibility
            let spacing: CGFloat = 8
            
            ZStack {
                // Background area
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)
                    .frame(width: geometry.size.width, height: containerHeight)
                
                HStack(spacing: spacing) {
                    ForEach(0..<3, id: \.self) { columnIndex in
                        VStack(spacing: 0) {
                            // Basket with eggs inside (ZStack approach) - ONLY SHOW IF HAS EGGS
                            if let basket = baskets.first(where: { $0.columnIndex == columnIndex }), basket.eggs > 0 {
                                ZStack {
                                    // Basket
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.8, green: 0.6, blue: 0.4),
                                                    Color(red: 0.7, green: 0.5, blue: 0.3)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: itemSize * 2.0, height: itemSize * 1.4) // Larger basket
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.brown, lineWidth: 2)
                                        )
                                    
                                    // Eggs inside basket - arranged in ZStack with LARGER SIZE
                                    ZStack {
                                        // First egg - LARGER SIZE
                                        Image("egg_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: itemSize * 0.8, height: itemSize * 0.8) // Larger eggs
                                            .offset(x: -itemSize * 0.25, y: -itemSize * 0.15)
                                        
                                        // Second egg (if exists)
                                        if basket.eggs >= 2 {
                                            Image("egg_icon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: itemSize * 0.8, height: itemSize * 0.8)
                                                .offset(x: itemSize * 0.25, y: -itemSize * 0.15)
                                        }
                                        
                                        // Third egg (if exists)
                                        if basket.eggs >= 3 {
                                            Image("egg_icon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: itemSize * 0.8, height: itemSize * 0.8)
                                                .offset(y: itemSize * 0.2)
                                        }
                                        
                                        // Fourth egg (if exists)
                                        if basket.eggs >= 4 {
                                            Image("egg_icon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: itemSize * 0.7, height: itemSize * 0.7)
                                                .offset(x: -itemSize * 0.15, y: itemSize * 0.15)
                                        }
                                    }
                                    
                                    // Basket handle
                                    Capsule()
                                        .fill(Color.brown)
                                        .frame(width: itemSize * 1.4, height: 4)
                                        .offset(y: -itemSize * 0.9)
                                }
                                .frame(height: itemSize * 1.8)
                                .padding(.bottom, 8)
                            } else {
                                // Empty space when no eggs
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: itemSize * 1.8)
                                    .padding(.bottom, 8)
                            }
                            
                            // Balls in column (4 balls per column)
                            VStack(spacing: 4) {
                                ForEach(0..<4, id: \.self) { positionIndex in
                                    let ball = ballAtPosition(columnIndex, positionIndex)
                                    if ball.isVisible && !disappearingBalls.contains(ball.id) {
                                        GlowingGlassBall(ballType: ball.ballType, size: itemSize * 0.9)
                                            .scaleEffect(disappearingBalls.contains(ball.id) ? 0.1 : 1.0)
                                            .opacity(disappearingBalls.contains(ball.id) ? 0 : 1)
                                            .frame(width: itemSize, height: itemSize)
                                    } else {
                                        // Empty space for invisible balls
                                        Circle()
                                            .fill(Color.clear)
                                            .frame(width: itemSize, height: itemSize)
                                    }
                                }
                            }
                            
                            Spacer(minLength: 0)
                        }
                        .frame(width: (geometry.size.width - spacing * 2) / 3)
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


// MARK: - UPDATED TriangleLevelView for better visualization
struct TriangleLevelView: View {
    let ballPositions: [BallPosition]
    let eggPositions: [EggPosition]
    let disappearingBalls: [UUID]
    let eggAtPosition: (Int, Int) -> EggPosition?
    let ballAtPosition: (Int, Int) -> BallPosition
    
    var body: some View {
        GeometryReader { geometry in
            let containerSize = min(geometry.size.width, geometry.size.height)
            let itemSize = containerSize / 7
            
            ZStack {
                // Draw triangle pattern - ROWS from top to bottom
                ForEach(0..<3, id: \.self) { rowIndex in
                    let ballsInRow = 3 - rowIndex // 3, 2, 1 balls per row
                    let yOffset = CGFloat(rowIndex) * itemSize * 1.5
                    let totalWidth = CGFloat(ballsInRow) * itemSize * 1.2
                    let startX = (geometry.size.width - totalWidth) / 2
                    
                    HStack(spacing: itemSize * 0.2) {
                        ForEach(0..<ballsInRow, id: \.self) { positionIndex in
                            ZStack {
                                // Check for egg
                                if let egg = eggAtPosition(rowIndex, positionIndex),
                                   egg.isVisible && !egg.isCollected {
                                    Image("egg_ball")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: itemSize, height: itemSize)
                                        .blinking()
                                }
                                
                                // Check for ball
                                let ball = ballAtPosition(rowIndex, positionIndex)
                                if ball.isVisible && !disappearingBalls.contains(ball.id) {
                                    GlowingGlassBall(ballType: ball.ballType, size: itemSize)
                                        .scaleEffect(disappearingBalls.contains(ball.id) ? 0.1 : 1.0)
                                        .opacity(disappearingBalls.contains(ball.id) ? 0 : 1)
                                }
                            }
                            .frame(width: itemSize, height: itemSize)
                        }
                    }
                    .offset(x: 0, y: yOffset - containerSize * 0.1)
                    
                    // Add row labels with egg count
                    VStack(spacing: 2) {
                        Text(getRowColorName(rowIndex))
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                        
                        let eggsInRow = eggPositions.filter {
                            $0.lineIndex == rowIndex && !$0.isCollected
                        }.count
                        Text("\(eggsInRow) eggs")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.yellow)
                    }
                    .padding(4)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(4)
                    .offset(x: geometry.size.width * 0.4, y: yOffset - containerSize * 0.1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func getRowColorName(_ rowIndex: Int) -> String {
        switch rowIndex {
        case 0: return "Red Row"
        case 1: return "Blue Row"
        case 2: return "Yellow Row"
        default: return "Red Row"
        }
    }
}

// MARK: - Level Views

struct HexagonLevelView: View {
    let ballPositions: [BallPosition]
    let eggPositions: [EggPosition]
    let disappearingBalls: [UUID]
    let eggAtPosition: (Int, Int) -> EggPosition?
    let ballAtPosition: (Int, Int) -> BallPosition
    let circleCenter: CGPoint
    
    var body: some View {
        GeometryReader { geometry in
            let containerSize = min(geometry.size.width, geometry.size.height)
            let circleDiameter = containerSize * 0.7
            let circleRadius = circleDiameter / 2
            let itemSize = circleDiameter / 10
            
            ZStack {
                // Hexagon outline for visual reference
                HexagonShape()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: circleDiameter, height: circleDiameter)
                
                // Balls and Eggs
                ForEach(0..<6, id: \.self) { lineIndex in
                    ForEach(1..<4, id: \.self) { positionIndex in
                        let angle = Double(lineIndex) * (2 * .pi / 6)
                        let radiusPercentage = CGFloat(positionIndex) / 3.0
                        let radius = circleRadius * radiusPercentage * 0.9
                        let x = cos(angle) * radius
                        let y = sin(angle) * radius
 
                        ZStack {
                            // Check for egg first
                            if let egg = eggPositions.first(where: {
                                $0.lineIndex == lineIndex &&
                                $0.positionIndex == positionIndex &&
                                $0.isVisible && !$0.isCollected
                            }) {
                                Image("egg_ball")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: itemSize, height: itemSize)
                                    .offset(x: x, y: y)
                                    .blinking()
                            }
                            // If no egg, check for ball
                            else {
                                let ball = ballAtPosition(lineIndex, positionIndex)
                                if ball.isVisible && !disappearingBalls.contains(ball.id) {
                                    GlowingGlassBall(ballType: ball.ballType, size: itemSize * 0.9)
                                        .scaleEffect(disappearingBalls.contains(ball.id) ? 0.1 : 1.0)
                                        .opacity(disappearingBalls.contains(ball.id) ? 0 : 1)
                                        .offset(x: x, y: y)
                                }
                            }
                        }
                    }
                }
                
                // Center point
                Circle()
                    .fill(Color.red.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
            .frame(width: circleDiameter, height: circleDiameter)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = Double(i) * (2 * .pi / 6) - .pi / 2
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        return path
    }
}

struct RectangleLevelView: View {
    let ballPositions: [BallPosition]
    let eggPositions: [EggPosition]
    let disappearingBalls: [UUID]
    let eggAtPosition: (Int, Int) -> EggPosition?
    let ballAtPosition: (Int, Int) -> BallPosition
    
    var body: some View {
        GeometryReader { geometry in
            let itemSize = min(geometry.size.width, geometry.size.height) / 7
            let spacing: CGFloat = 8
            
            HStack(spacing: spacing) {
                ForEach(0..<6, id: \.self) { lineIndex in
                    VStack(spacing: spacing) {
                        ForEach(0..<6, id: \.self) { positionIndex in
                            ZStack {
                                if let egg = eggAtPosition(lineIndex, positionIndex),
                                   egg.isVisible && !egg.isCollected {
                                    Image("egg_ball")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: itemSize, height: itemSize)
                                        .blinking()
                                }
                                
                                let ball = ballAtPosition(lineIndex, positionIndex)
                                if ball.isVisible && !disappearingBalls.contains(ball.id) {
                                    GlowingGlassBall(ballType: ball.ballType, size: itemSize)
                                        .scaleEffect(disappearingBalls.contains(ball.id) ? 0.1 : 1.0)
                                        .opacity(disappearingBalls.contains(ball.id) ? 0 : 1)
                                }
                            }
                            .frame(width: itemSize, height: itemSize)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

struct CircleLevelView: View {
    let ballPositions: [BallPosition]
    let eggPositions: [EggPosition]
    let disappearingBalls: [UUID]
    let eggAtPosition: (Int, Int) -> EggPosition?
    let ballAtPosition: (Int, Int) -> BallPosition
    let circleCenter: CGPoint
    
    var body: some View {
        GeometryReader { geometry in
            let containerSize = min(geometry.size.width, geometry.size.height)
            let circleDiameter = containerSize * 0.8
            let circleRadius = circleDiameter / 2
            let itemSize = circleDiameter / 12
            
            ZStack {
          
                // Balls and Eggs
                ForEach(0..<6, id: \.self) { lineIndex in
                    ForEach(1..<6, id: \.self) { positionIndex in
                        let angle = Double(lineIndex) * (2 * .pi / 6)
                        let radiusPercentage = CGFloat(positionIndex) / 5.0
                        let radius = circleRadius * radiusPercentage * 0.8
                        let x = cos(angle) * radius
                        let y = sin(angle) * radius
 
                        ZStack {
                            // Check for egg first
                            if let egg = eggPositions.first(where: {
                                $0.lineIndex == lineIndex &&
                                $0.positionIndex == positionIndex &&
                                $0.isVisible && !$0.isCollected
                            }) {
                                Image("egg_ball")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: itemSize, height: itemSize)
                                    .offset(x: x, y: y)
                                    .blinking()
                            }
                            // If no egg, check for ball
                            else {
                                let ball = ballAtPosition(lineIndex, positionIndex)
                                if ball.isVisible && !disappearingBalls.contains(ball.id) {
                                    GlowingGlassBall(ballType: ball.ballType, size: itemSize * 0.9)
                                        .scaleEffect(disappearingBalls.contains(ball.id) ? 0.1 : 1.0)
                                        .opacity(disappearingBalls.contains(ball.id) ? 0 : 1)
                                        .offset(x: x, y: y)
                                }
                            }
                        }
                    }
                }
                
                // Center point
                Circle()
                    .fill(Color.red.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
            .frame(width: circleDiameter, height: circleDiameter)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}


struct CustomBasketView: View {
    let balls: [String]
    
    var body: some View {
        ZStack {
            // 3D Basket
            ZStack {
                // Basket Back Side
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [Color.brown.opacity(0.6), Color.brown.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 110, height: 80)
                    .offset(y: 5)
                
                // Basket Front Side
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.8, green: 0.6, blue: 0.4),
                                Color(red: 0.7, green: 0.5, blue: 0.3),
                                Color(red: 0.6, green: 0.4, blue: 0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.brown.opacity(0.8), Color.brown],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                
                // Basket Weave Pattern
                VStack(spacing: 4) {
                    ForEach(0..<4, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<6, id: \.self) { col in
                                Rectangle()
                                    .fill(
                                        (row + col).isMultiple(of: 2) ?
                                        Color.brown.opacity(0.3) :
                                        Color.orange.opacity(0.2)
                                    )
                                    .frame(width: 15, height: 3)
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                // Basket Handle
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.brown, Color.orange.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 70, height: 8)
                    .offset(y: -45)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
            }
            
            // Balls in basket - All 6 glowing glass balls arranged properly
            ZStack {
                // Bottom row - 3 balls
                if balls.count > 3 {
                    GlowingBallView(ballType: balls[3])
                        .offset(x: -20, y: 12)
                }
                if balls.count > 4 {
                    GlowingBallView(ballType: balls[4])
                        .offset(x: 0, y: 12)
                }
                if balls.count > 5 {
                    GlowingBallView(ballType: balls[5])
                        .offset(x: 20, y: 12)
                }
                
                // Middle row - 2 balls
                if balls.count > 1 {
                    GlowingBallView(ballType: balls[1])
                        .offset(x: -10, y: 0)
                }
                if balls.count > 2 {
                    GlowingBallView(ballType: balls[2])
                        .offset(x: 10, y: 0)
                }
                
                // Top row - 1 ball
                if balls.count > 0 {
                    GlowingBallView(ballType: balls[0])
                        .offset(x: 0, y: -12)
                }
            }
            .offset(y: -5)
        }
        .scaleEffect(0.9)
    }
}

struct GlowingBallView: View {
    let ballType: String
    
    var body: some View {
        GlowingGlassBall(ballType: ballType, size: 28)
            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)
    }
}

struct ProgressBarView: View {
    let progress: CGFloat
    let levels: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.orange)
                    .frame(width: min(progress * geometry.size.width, geometry.size.width), height: geometry.size.height)
                
                HStack(spacing: 0) {
                    ForEach(0..<(levels-1), id: \.self) { index in
                        Spacer()
                        Rectangle()
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 2, height: geometry.size.height)
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
    }
}



// MARK: - Sound Manager
import AVFoundation

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var players: [String: AVAudioPlayer] = [:]
    
    private init() {
        // Preload sounds
        preloadSound(name: "ball_hit", type: "mp3")
        preloadSound(name: "egg_flying", type: "mp3")
    }
    
    private func preloadSound(name: String, type: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            print("Sound file \(name).\(type) not found")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.prepareToPlay()
            players[name] = player
        } catch {
            print("Error loading sound \(name): \(error.localizedDescription)")
        }
    }
    
    func playSound(named name: String) {
        guard let player = players[name] else {
            print("Sound \(name) not found")
            return
        }
        
        // Stop if already playing and restart
        if player.isPlaying {
            player.stop()
        }
        
        player.currentTime = 0
        player.play()
    }
    
    func stopSound(named name: String) {
        players[name]?.stop()
    }
    
    func stopAllSounds() {
        players.values.forEach { $0.stop() }
    }
}

