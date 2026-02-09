// =============================================================================
// SKILLZ INTEGRATION CHANGES FOR MainGameView.swift
// =============================================================================
// Apply these changes to your existing MainGameView.swift file

// 1. ADD these properties at the top of MainGameView struct (after existing @State properties)

    // Skillz Integration Properties
    var isSkillzTournament: Bool = false
    var skillzMatchInfo: SKZMatchInfo? = nil
    @State private var finalScoreReported: Bool = false

// =============================================================================

// 2. UPDATE the MainGameView initializer to accept Skillz parameters

struct MainGameView: View {
    
    @State private var progress: CGFloat = 0.0
    @State private var score: Int = 0
    @State private var collectedEggs: Int = 0
    @State private var currentLevel: Int = 1

    var startingLevel: Int = 1
    
    // ADD THESE NEW PARAMETERS
    var isSkillzTournament: Bool = false
    var skillzMatchInfo: SKZMatchInfo? = nil
    
    // ... rest of your existing properties ...
    
    @State private var finalScoreReported: Bool = false

// =============================================================================

// 3. ADD this method to report scores to Skillz (add after your existing methods)

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
        Skillz.skillzInstance().displayTournamentResults(withScore: NSNumber(value: finalScore))
        
        print("✅ Score reported successfully to Skillz")
    }
    
    private func shouldReportScore() -> Bool {
        // Report score when:
        // 1. All levels are completed, OR
        // 2. Time runs out
        return isSkillzTournament && !finalScoreReported
    }

// =============================================================================

// 4. UPDATE handleTimeUp method to report score

    private func handleTimeUp() {
        stopTimer()
        
        // STOP ALL SOUNDS when time is up
        soundManager.stopAllSounds()
        
        // Calculate final score
        let finalScore = totalGameScore + score
        
        // REPORT SCORE TO SKILLZ if in tournament mode
        if shouldReportScore() {
            reportScoreToSkillz(finalScore: finalScore)
            // Don't show game over screen, Skillz will handle it
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

// =============================================================================

// 5. UPDATE transitionToNextLevel method to report score when all levels complete

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
                // Normal mode - show completion screen
                showAllLevelsComplete = true
            }
        }
    }

// =============================================================================

// 6. UPDATE restartCurrentLevel to prevent restarting in Skillz tournaments

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

// =============================================================================

// 7. UPDATE restartEntireGame to prevent restarting in Skillz tournaments

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

// =============================================================================

// 8. UPDATE handleBackToMenu to prevent exiting in Skillz tournaments

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

// =============================================================================

// 9. UPDATE the body's back button action

    // In your body's ZStack, update the back button:
    
    // Back Button
    Button(action: {
        pauseTimer()
        
        // Check if in Skillz tournament
        if isSkillzTournament {
            // Show confirmation alert
            handleBackToMenu()
        } else {
            dismiss()
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

// =============================================================================

// 10. ADD Skillz tournament indicator in the UI (OPTIONAL but recommended)

    // Add this to your header section to show when in tournament mode:
    
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

// =============================================================================

// 11. UPDATE onAppear to log tournament status

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

// =============================================================================
// END OF SKILLZ INTEGRATION CHANGES
// =============================================================================
