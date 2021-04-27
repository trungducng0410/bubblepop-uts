//
//  GameViewController.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 21/04/2021.
//

import UIKit
import AudioToolbox

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var gameAreaView: UIView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    private let defaults = UserDefaults.standard
    
    private var remainingTime = 60
    private var currentScore = 0
    private var highScore = 0
    
    private var playerName: String = "PlayerName"
    private var gameDuration: Int = 60
    private var maxBubbles: Int = 15
    
    private var lastBubbleType: BubbleType?
    private var bubbles = [(bubble: Bubble, gesture: UITapGestureRecognizer)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerName = defaults.string(forKey: "name") ?? "PlayerName"
        self.gameDuration = defaults.integer(forKey: "gameDuration")
        self.maxBubbles = defaults.integer(forKey: "maximumBubbles")
        
        initLabels()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func initLabels() {
        playerNameLabel.text = playerName
        
        remainingTime = gameDuration
        timeLabel.text = String(remainingTime)
        
        highScore = Helper.getHighestScore()
        highScoreLabel.text = String(highScore)
        
        scoreLabel.text = "0"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if let currNumber = Int(self.countDownLabel.text ?? "0") {
                if currNumber == 1 {
                    timer.invalidate()
                    self.countDownLabel.isHidden = true
                    self.startGame()
                }
                else {
                    UIView.transition(with: self.countDownLabel, duration: 0.1, options: .transitionCrossDissolve, animations: {
                      self.countDownLabel.text = String(currNumber - 1)
                    })
                }
            }
        }).fire()
    }
    
    // for handling touch events on the game view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            handleTouchInGameView(touch.location(in: gameAreaView))
        }
    }
    
    // for handling touch events on buttons that otherwise would
    // not propagate to the game view
    @objc func buttonTouchGestureHandler(sender: UITapGestureRecognizer) {
        let point = sender.location(in: gameAreaView)
        handleTouchInGameView(point)
    }
    
    // when a touch occurs in the game view, iterate the bubbles collection
    // and check to see if any should be popped
    private func handleTouchInGameView(_ point: CGPoint) {
        for (bubble, _) in bubbles {
            if bubble.isPointInside(point) {
                bubble.successfulTouch()
                break
            }
        }
    }
    
    func startGame() {
        print("Start")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.remainingTime == 0 {
                timer.invalidate()
                self.endGame()
            } else {
                self.clearBubbles(all: self.remainingTime == 1)
                if self.remainingTime != 1 {
                    self.generateBubbles()
                }
                self.remainingTime -= 1
                self.timeLabel.text = String(self.remainingTime)
                self.updateTimerLabel()
            }
        }).fire()
    }
    
    func clearBubbles(all: Bool = false) {
        for (bubble, _) in bubbles {
            if !bubble.isRemoving && (all || Int.random(in: 0 ... 20) == 20 || isBubbleOffScreen(bubble)) {
                bubble.disappear(onAnimComplate: removeBubble)
            }
        }
    }
    
    func generateBubbles() {
        
        // calculate bubble size based of width of screen
        let buttonSize = Double(gameAreaView.frame.width / 6)
        let halfButtonSize = buttonSize / 2.0
        
        // limit area button can spawn
        let buttonXRange = halfButtonSize ... Double(gameAreaView.frame.width - CGFloat(halfButtonSize + 1))
        let buttonYRange = halfButtonSize ... Double(gameAreaView.frame.height - CGFloat(halfButtonSize + 1))
        
        let maxTries = 20
        let numBubblesToSpawn = Int.random(in: 0 ... self.maxBubbles - bubbles.count)
        var newBubbles = [Bubble]()
        
        for _ in 0 ..< numBubblesToSpawn {
            // generate random coordinate then check overlap
            var counter = 0
            var randPoint: CGPoint
            repeat {
                counter += 1
                randPoint = CGPoint(x: Double.random(in: buttonXRange), y: Double.random(in: buttonYRange))
            } while counter < maxTries && !isSpawnPointFree(point: randPoint)
            
            // stop when reach max tries to avoid infinite loop
            if counter >= maxTries {
                break
            }
            
            // create new bubble
            let newBubble = Bubble(center: randPoint, size: buttonSize, type: getRandomBubbleType(), onPopped: bubblePopped)
            
            // set manual trigger touch event
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.buttonTouchGestureHandler))
            newBubble.addGestureRecognizer(gesture)
            
            // add bubble to bubble list and show it
            newBubbles.append(newBubble)
            bubbles.append((bubble: newBubble, gesture: gesture))
            gameAreaView.addSubview(newBubble)
        }
        
        newBubbles.forEach({ $0.appear() })
    }
    
    func getRandomBubbleType() -> BubbleType {
        // sum all pct of bubble type
        let totalPercent = BubbleType.allCases.reduce(0, { $0 + $1.rawValue })
        
        // pick random float
        let randPercent = Float.random(in: 0 ... totalPercent)
        var temp: Float = 0
        for bubbleType in BubbleType.allCases {
            if temp ... (temp + bubbleType.rawValue) ~= randPercent {
                return bubbleType
            }
            
            temp += bubbleType.rawValue
        }
        
        // return default bubble type
        return BubbleType.allCases[0]
    }
    
    func isSpawnPointFree(point: CGPoint) -> Bool {
        for (bubble, _) in bubbles {
            if (!bubble.isRemoving) {
                let center = bubble.presentationCenter ?? bubble.center
                let diameter = Double(bubble.maxFrame.width * 1.2)
                if Distance.Distance(point, center) <= diameter {
                    return false
                }
            }
        }
        
        return true
    }
    
    func bubblePopped(_ bubble: Bubble) {
        // prevent double tap
        bubble.isEnabled = false
        
        if bubble.bubbleType == BubbleType.clock {
            remainingTime += 10
            timeLabel.text = String(remainingTime)
            updateTimerLabel()
        }
        
        if bubble.bubbleType == BubbleType.boom {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        var scoreMultiplier = 1.0
        if lastBubbleType != nil && bubble.bubbleType == lastBubbleType! {
            scoreMultiplier = 1.5
        }
        
        lastBubbleType = bubble.bubbleType
        
        let score = Int(round(scoreMultiplier * Double(bubble.pointValue)))
        if currentScore + score < 0 {
            currentScore = 0
        } else {
            currentScore += score
        }
        scoreLabel.text = String(currentScore)
        
        //#TODO spawn floating label
        generateLabel(bubble: bubble, value: score, multiplier: scoreMultiplier)
        
        removeBubble(bubble)
    }
    
    func removeBubble(_ bubble: Bubble) {
        if let index = bubbles.firstIndex(where: { $0.bubble == bubble }) {
            gameAreaView.removeGestureRecognizer(bubbles[index].gesture)
            bubbles.remove(at: index)
        }
    }
    
    func generateLabel(bubble: Bubble, value: Int, multiplier: Double = 1.0) {
        let label = UILabel()
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        
        if bubble.bubbleType == BubbleType.clock {
            label.text = "+10s"
        } else if bubble.bubbleType == BubbleType.boom {
            label.text = "\(String(value))"
        } else {
            label.text = multiplier == 1.0 ? "+\(String(value))" : "Combo!\n+\(String(value))"
        }
        label.numberOfLines = 2
        let fontSize = bubble.maxFrame.height / 2
        label.font = UIFont(name: "BubbleBobble", size: fontSize) ?? label.font.withSize(fontSize)
        label.sizeToFit()
        label.center = bubble.presentationCenter ?? bubble.center
        label.layer.zPosition = 1
        label.textColor = bubble.textColor
        gameAreaView.addSubview(label)
        
        
        // move label along with bubble
        let animMoveSpeed = -label.font.lineHeight / 2
        let animDuration = 1.0
        let animYOffset = animMoveSpeed * CGFloat(animDuration)
        UIView.animate(
            withDuration: animDuration,
            delay: 0,
            options: .curveLinear,
            animations: {
                label.transform = CGAffineTransform.identity.translatedBy(x: 0, y: animYOffset)
                label.alpha = 0
            },
            completion: { Void in()
                label.removeFromSuperview()
            }
        )
    }
    
    func isBubbleOffScreen(_ bubble: Bubble) -> Bool {
        if let center = bubble.presentationCenter {
            return center.y < gameAreaView.frame.minY
        }
        
        return false
    }
    
    func endGame() {
        performSegue(withIdentifier: "gameOver", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? GameOverViewController {
            target.playerName = self.playerName
            target.score = self.currentScore
        }
    }
    
    func updateTimerLabel() {
        let timeFraction = Float(self.remainingTime) / Float(self.gameDuration)
        var newColor: UIColor
        switch timeFraction {
        case 0..<0.33:
            newColor = .red
        case 0.33..<0.66:
            newColor = .orange
        default:
            newColor = .green
        }
        
        UIView.transition(with: self.timeLabel, duration: 0.1, options: .transitionCrossDissolve, animations: {
          self.timeLabel.textColor = newColor
        })
    }
}
