//
//  ScoreTableViewCell.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 13/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var scoreInfoLabel: UILabel!
    
    func setUserScore(userScore: PlayerScore) {
        scoreInfoLabel.text = "Name: \(userScore.name!) | Difficulty: \(userScore.difficulty!) | Score: \(userScore.score)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
