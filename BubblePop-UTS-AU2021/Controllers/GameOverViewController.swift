//
//  GameOverViewController.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 24/04/2021.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    private var defaults = UserDefaults.standard
    private var defaultHighScore = 0
    
    var playerName: String = "Player"
    var score: Int = 0
    
    var highScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerScoreLabel.text = String(self.score)
        highScore = Helper.getHighestScore()
        if self.score > self.highScore {
            highScoreLabel.text = String(self.score)
        } else {
            highScoreLabel.text = String(highScore)
        }
        handleGameOver()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func handleGameOver() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.savePlayer(name: self.playerName, score: Int16(self.score))
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        // go back to menu
        navigationController?.popToRootViewController(animated: true)
    }
}
