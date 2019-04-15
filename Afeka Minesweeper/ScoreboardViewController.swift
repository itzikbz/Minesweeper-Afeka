//
//  ScoreboardViewController.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 13/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//

import UIKit

class ScoreboardViewController: UIViewController {
    
    var userScore = [PlayerScore]()
    
    @IBOutlet weak var scoreUITableView: UITableView!
    
    //sets init data and get the userscore model
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreUITableView.delegate = self
        scoreUITableView.dataSource = self
        userScore = PersistenceService.getUserScore()
    }
    
}

//an extension for implmenting the table view delegate and data source
extension ScoreboardViewController: UITableViewDataSource, UITableViewDelegate {
    //numver of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScore.count
    }
    
    //data of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let score = userScore[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! ScoreTableViewCell
        
        cell.setUserScore(userScore: score)
        
        return cell
    }
}
