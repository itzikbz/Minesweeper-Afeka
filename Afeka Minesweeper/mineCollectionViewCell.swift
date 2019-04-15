//
//  mineCollectionViewCell.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 10/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//

import UIKit

class mineCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var gameImageView: UIImageView!
    
    var cellData: CellData?
    
    //sets the data of the mine into the cell
    func setCellData(cellData: CellData) {
        self.cellData = cellData
        gameImageView.image = UIImage(named: cellData.imageName)
        if(!cellData.isDiscoverd) {
            if !cellData.isFlag {
                frontImageView.image = UIImage(named: "cover_icon")
            } else  {
                frontImageView.image = UIImage(named: "flag_icon")
            }
        }
    }
    
    //Discover cell within doing a transition
    func dicover(){
        UIView.transition(from: frontImageView,to: gameImageView, duration: 0.2, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        cellData?.isDiscoverd = true
    }
    
    //sets a cell as a flag
    func setFlag(){
        var imageName = ""
        if((cellData?.isFlag)!) {
            imageName = "cover_icon"
            cellData?.isFlag = false
        } else {
            imageName = "flag_icon"
            cellData?.isFlag = true
        }
        frontImageView.image = UIImage(named: imageName)
        
    }
    
    func isMine() -> Bool {
        return cellData?.isMine == true
    }
    
    func isNearbyMine() -> Bool {
        return (cellData?.nearbyMines)! != 0
    }
    
    func isDiscoverd() -> Bool {
        return (cellData?.isDiscoverd)!
    }
    
    func isFlag() -> Bool {
        return (cellData?.isFlag)!
    }
}

