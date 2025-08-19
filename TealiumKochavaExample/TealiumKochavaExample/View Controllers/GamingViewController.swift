//
//  GamingViewController.swift
//  TealiumKochavaExample
//
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

class GamingViewController: UIViewController {

    @IBOutlet weak var startTutorialButton: UIButton!
    @IBOutlet weak var stopTutorialButton: UIButton!
    @IBOutlet weak var achievementLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!

    var data = [String: Any]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TealiumHelper.trackScreen(self, name: "gaming")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    

    @objc func share() {
        TealiumHelper.trackEvent(title: "share", data: [GamingViewController.contentType: "gaming screen", GamingViewController.shareId: "gamqwe123"])
        let vc = UIActivityViewController(activityItems: ["Gaming"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    
    @IBAction func achievementSwitch(_ sender: UISwitch) {
        if sender.isOn {
            let achievementId = "ACHIEVEMENT_\(Int.random(in: 1...1000))"
            
            // Use enhanced method from TealiumHelper
            TealiumHelper.trackAchievement(achievementId: achievementId, description: "Random test achievement unlocked")
            
            // Additional data for testing
            TealiumHelper.trackEvent(title: "unlock_achievement", data: [
                GamingViewController.achievementId: achievementId,
                "achievement_type": "random_test",
                "player_level": Int.random(in: 1...50),
                "time_played": Int.random(in: 60...3600), // seconds
                "difficulty": ["easy", "medium", "hard"].randomElement() ?? "medium"
            ])
            
            achievementLabel.text = "Lock Achievement"
        } else {
            achievementLabel.text = "Unlock Achievement"
        }
    }
    
    @IBAction func ratingStepper(_ sender: UIStepper) {
        let rating = Int(sender.value)
        levelLabel.text = String(rating)
        
        // Add rich rating data
        let ratingData: [String: Any] = [
            GamingViewController.rating: rating,
            "rating_value": Double(rating),
            "max_rating_value": 10.0,
            "item_rated": "game_experience",
            "user_level": Int.random(in: 1...50),
            "session_duration": Int.random(in: 60...1800)
        ]
        
        TealiumHelper.trackEvent(title: "rating", data: ratingData)
    }
    
    @IBAction func startTrial(_ sender: UIButton) {
        let trialData: [String: Any] = [
            "trial_type": "premium",
            "trial_duration_days": 7,
            "trial_value": 9.99,
            "currency_code": "USD",
            "source": "gaming_screen"
        ]
        
        TealiumHelper.trackEvent(title: "start_trial", data: trialData)
    }
    
    @IBAction func completeTutorial(_ sender: UIButton) {
        let tutorialData: [String: Any] = [
            "tutorial_name": "basic_gameplay",
            "completion_time": Int.random(in: 30...300), // seconds
            "steps_completed": Int.random(in: 5...10),
            "help_used": Bool.random(),
            "completed": true
        ]
        
        TealiumHelper.trackEvent(title: "complete_tutorial", data: tutorialData)
    }
    
    @IBAction func completeLevel(_ sender: Any) {
        let level = "LEVEL_\(Int.random(in: 1...100))"
        let score = Int.random(in: 1...1000) * 1000
        let duration = TimeInterval(Int.random(in: 30...600))
        
        // Use enhanced method from TealiumHelper
        TealiumHelper.trackLevelComplete(level: level, score: score, duration: duration)
        
        // Additional data for levels
        let levelData: [String: Any] = [
            GamingViewController.score: score,
            "level": level,
            "stars_earned": Int.random(in: 1...3),
            "power_ups_used": Int.random(in: 0...5),
            "enemies_defeated": Int.random(in: 0...20),
            "coins_collected": Int.random(in: 0...100),
            "completion_percentage": Double.random(in: 80...100),
            "difficulty": ["easy", "medium", "hard"].randomElement() ?? "medium"
        ]
        
        TealiumHelper.trackEvent(title: "complete_level", data: levelData)
    }

}

extension GamingViewController {
    static let contentType = "content_type"
    static let shareId = "share_id"
    static let achievementId = "achievement_id"
    static let rating = "rating"
    static let score = "score"
}
