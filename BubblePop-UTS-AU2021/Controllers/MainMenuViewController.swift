//
//  ViewController.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 21/04/2021.
//

import UIKit

class MainMenuViewController: UIViewController {

    //IB Control outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    //private constants and variables
    private let defaults = UserDefaults.standard
    private var defaultPlayerName = "PlayerName"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nameTextField.text = defaults.object(forKey: "name") as? String ?? defaultPlayerName
        warningLabel.text = ""
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier == "PlayGameSegue" ? validateNameTextField() : true
    }
    
    func setPlayerName() {
        defaults.set(String(nameTextField.text!), forKey: "name")
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        setPlayerName()
    }
    
    @discardableResult func validateNameTextField() -> Bool {
        if let name = nameTextField.text, name != "" {
            nameTextField.layer.borderWidth = 0.0
            warningLabel.text = ""
            
            return true
        }
        else {
            nameTextField.layer.borderColor = UIColor.red.cgColor
            nameTextField.layer.borderWidth = 1.0
            nameTextField.layer.cornerRadius = 4.0
            nameTextField.layer.masksToBounds = true
            warningLabel.text = "Please enter player's name"
            
            return false
        }
    }
    
    @IBAction func nameTextFieldChanged(_ sender: Any) {
        validateNameTextField()
    }
    

}

