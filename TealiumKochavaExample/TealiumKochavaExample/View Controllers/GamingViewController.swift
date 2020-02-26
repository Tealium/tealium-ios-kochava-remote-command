//
//  GamingViewController.swift
//  TealiumFirebaseExample
//
//  Created by Christina Sund on 7/19/19.
//  Copyright © 2019 Christina. All rights reserved.
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
            TealiumHelper.trackEvent(title: "unlock_achievement", data: [GamingViewController.achievementId: "\(Int.random(in: 1...1000))"])
            achievementLabel.text = "Lock Achievement"
        } else {
            achievementLabel.text = "Unlock Achievement"
        }
        
    }
    
    @IBAction func ratingStepper(_ sender: UIStepper) {
        levelLabel.text = String(Int(sender.value))
        data[GamingViewController.rating] = String(Int(sender.value))
        TealiumHelper.trackEvent(title: "rating", data: data)
    }
    
    
    @IBAction func startTrial(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "start_trial", data: nil)
    }
    
    @IBAction func completeTutorial(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "complete_tutorial", data: nil)
    }
    
    @IBAction func completeLevel(_ sender: Any) {
        data[GamingViewController.score] = Int.random(in: 1...1000) * 1000
        TealiumHelper.trackEvent(title: "complete_level", data: data)
    }

}

extension GamingViewController {
    static let contentType = "content_type"
    static let shareId = "share_id"
    static let achievementId = "achievement_id"
    static let rating = "rating"
    static let score = "score"
}
