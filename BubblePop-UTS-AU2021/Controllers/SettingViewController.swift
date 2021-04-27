//
//  SettingViewController.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 23/04/2021.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var BubbleSlider: UISlider!
    @IBOutlet weak var TimeSlider: UISlider!
    @IBOutlet weak var bubbleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    //private constants and variables
    private let defaults = UserDefaults.standard
    private var defaultMaxBubbles = 15
    private var defaultGameDuration = 60
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 10
        
        initSetting()
    }
    
    func initSetting() {
        let maxBubbles = defaults.object(forKey: "maximumBubbles") as? Int ?? defaultMaxBubbles
        bubbleLabel.text = "Maximum Bubbles: \(maxBubbles)"
        BubbleSlider.value = Float(maxBubbles)
        
        let gameDuration = defaults.object(forKey: "gameDuration") as? Int ?? defaultGameDuration
        timeLabel.text = "Game Duration: \(gameDuration)"
        TimeSlider.value = Float(gameDuration)
    }
    
    @IBAction func maxBubblesSliderValueChanged(_ sender: UISlider) {
        bubbleLabel.text = "Maximum Bubbles: \(Int(sender.value))"
    }
    
    @IBAction func gameDurationSliderValueChanged(_ sender: UISlider) {
        timeLabel.text = "Game Duration: \(Int(sender.value))"
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        // save new setting
        defaults.set(Int(BubbleSlider.value), forKey: "maximumBubbles")
        defaults.set(Int(TimeSlider.value), forKey: "gameDuration")
        
        // go back to menu
        navigationController?.popToRootViewController(animated: true)
    }
}
