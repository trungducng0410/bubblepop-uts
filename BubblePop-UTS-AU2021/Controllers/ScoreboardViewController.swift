//
//  ScoreboardViewController.swift
//  BubblePop-UTS-AU2021
//
//  Created by Trung Duc on 24/04/2021.
//

import UIKit

class ScoreBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var scoreboardTable: UITableView!
    
    
    var players: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "scoreTableViewCell", bundle: nil)
        
        scoreboardTable.dataSource = self
        scoreboardTable.delegate = self
        scoreboardTable.register(nib, forCellReuseIdentifier: "cell")
        players = Helper.retrivePlayers()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoreboardTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! scoreTableViewCell
        cell.nameLabel?.text = players[indexPath.row].name
        cell.scoreLabel?.text = String(players[indexPath.row].score)
        return cell
    }
    
    
}
