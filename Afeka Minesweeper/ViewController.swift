//
//  ViewController.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 10/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController
{
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var minesCollectionView: UICollectionView!
    @IBOutlet weak var minesLeftLabel: UILabel!
    
    @IBOutlet weak var GameAnimation: UIImageView!

    //Game information
    var size = 0
    var mines = 0
    var nickname = ""
    var difficulty = ""
    
    //Data
    var model = MinesModel()
    var mineArray = [[CellData]]()
    var bombDiscovered = false
    var timer: Timer?
    var secondsPassed = 0
    var cellsLeft = 0
    var bombsLeft = 0
    
    //uiimage array for win and lose animations
    var winnerImages: [UIImage] = []
    var loserImages: [UIImage] = []
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sets data
        cellsLeft = size * size - mines
        bombsLeft = mines
        minesLeftLabel.text = "Mines Left: \(bombsLeft)"
        mineArray = model.getMineArray(size: size, mines: mines)
        playerName.text = nickname
        
        //set the animation arrays
        winnerImages = createImageArray(total: 11, imagePrefix: "tenor")
        loserImages = createImageArray(total: 35, imagePrefix: "loser")
        
        //sets delegate and datasource
        minesCollectionView.delegate = self
        minesCollectionView.dataSource = self
        
        //set longpress function for flags
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
    
        longPress.minimumPressDuration = 0.2
        minesCollectionView.addGestureRecognizer(longPress)
        
        //starts the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
    }
    
    
    //A recursive method which discoers the cell after one click on it
    func dicoverCell(indexPath: IndexPath) {
        //get the desired cell
        let cell = minesCollectionView.cellForItem(at: indexPath) as! mineCollectionViewCell
        
        //If it is dicovered or flagged, do nothing
        if(cell.isDiscoverd() || cell.isFlag()) {
            return
        }
        
        //If the cell is mine - end the game, othewise decrease the cell left count
        if(cell.isMine()) {
            bombDiscovered = true
            timer?.invalidate()
            showGameoverAlert(gameWon: false)
        } else {
            cellsLeft -= 1
        }
        
        //discover the cell
        cell.dicover()
        
        //If cells left is zero - the game won
        if(cellsLeft == 0) {
            timer?.invalidate()
            addScoreToDB()
            showGameoverAlert(gameWon: true)
        }
        
        //Check eight nearby possible cells if they are not mines
        if(!cell.isMine() && !cell.isNearbyMine() && !bombDiscovered) {
            if indexPath.row > size - 1 {
                let newIndexPath = IndexPath(row: indexPath.row - size, section: indexPath.section)
                dicoverCell(indexPath: newIndexPath)
                
                if indexPath.row % size > 0 {
                    let newIndexPath = IndexPath(row: indexPath.row - size - 1, section: indexPath.section)
                    dicoverCell(indexPath: newIndexPath)
                }
                
                if indexPath.row % size < size - 1 {
                    let newIndexPath = IndexPath(row: indexPath.row - size + 1, section: indexPath.section)
                    dicoverCell(indexPath: newIndexPath)
                }
            }
            
            if indexPath.row < size*(size-1) {
                let newIndexPath = IndexPath(row: indexPath.row + size, section: indexPath.section)
                dicoverCell(indexPath: newIndexPath)
                
                if indexPath.row % size > 0{
                    let newIndexPath = IndexPath(row: indexPath.row + size - 1, section: indexPath.section)
                    dicoverCell(indexPath: newIndexPath)
                }
                
                if indexPath.row % size < size - 1 {
                    let newIndexPath = IndexPath(row: indexPath.row + size + 1, section: indexPath.section)
                    dicoverCell(indexPath: newIndexPath)
                }
            }
            if indexPath.row % size > 0{
                let newIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                dicoverCell(indexPath: newIndexPath)
            }
            
            if indexPath.row % size < size - 1 {
                let newIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                dicoverCell(indexPath: newIndexPath)
            }
        }
    }
    
    //adds the user score to the data base
    func addScoreToDB() {
        let playerScore = PlayerScore(context: PersistenceService.context)
        playerScore.difficulty = difficulty
        playerScore.name = nickname
        playerScore.score = Double(getScore())
        PersistenceService.saveContext()
    }
    
    //go to score views
    func openScoreView(alert: UIAlertAction) {
        performSegue(withIdentifier: "openScoreView", sender: self)
    }
    
    //go to loby view
    func openLobyView(alert: UIAlertAction) {
        performSegue(withIdentifier: "BackToLoby", sender: self)
    }
    
    //decide the user score according to the difficulty and the time
    func getScore() -> Double {
        var score = 500.00
        switch difficulty {
        case "Easy":
            let timerBonus = ((120 - Double(secondsPassed))/80)*1000
            print(timerBonus)
            if(timerBonus > 0) {
                score += timerBonus
            }
            break
        case "Normal":
            score += 1000.00
            let timerBonus = ((240 - Double(secondsPassed))/360)*2000
            if(timerBonus > 0) {
                score += timerBonus
            }
            break
        case "Hard":
            score += 2000.00
            let timerBonus = ((360 - Double(secondsPassed))/600)*3000
            if(timerBonus > 0) {
                score += timerBonus
            }
            break
        default:
            break
        }
        return round(score)
    }
    
    //time process function
    @objc func processTimer() {
        secondsPassed += 1
        counterLabel.text = "\(secondsPassed)"
    }
    
    //show game over alert
    func showGameoverAlert(gameWon: Bool) {
        var message = "";
        if gameWon {
            message = "Game Won";
            animate(imageView: GameAnimation, images: winnerImages)
        } else {
            message = "Game Lost";
            animate(imageView: GameAnimation, images: loserImages)
        }
        let gameOverMenu = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        let openScoreboardAction = UIAlertAction(title: "Go to Scores", style: .default, handler: openScoreView)
        let openMenuAction = UIAlertAction(title: "Go to Menu", style: .default, handler: openLobyView)
        gameOverMenu.addAction(openScoreboardAction)
        gameOverMenu.addAction(openMenuAction)
        self.present(gameOverMenu, animated: true, completion: nil)
    }
    
    //Create an image array by its size(total) and prefix
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount).png"
            let image =  UIImage(named: imageName)!
            imageArray.append(image)
        }
        return imageArray;
        
    }
    
    //animates uiiamgeview with an animation
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = 10
        imageView.startAnimating()
    }
}



//An extension for implmenting delegate and datasource methods
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //size of the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size*size
    }
    
    //the data of each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = minesCollectionView.dequeueReusableCell(withReuseIdentifier: "MineCell", for: indexPath) as! mineCollectionViewCell
        let mineCell = mineArray[(indexPath.row/size)][(indexPath.row%size)]
        cell.setCellData(cellData: mineCell)
        return cell
    }
    
    //Method call on cell click
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!bombDiscovered) {
            dicoverCell(indexPath: indexPath)
        }
    }
    
    //Spliting the cell into fixed number of rows - I got help rom stackOverFlow implmenting this
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = self.size
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }
}

//extension for implmenting the long press function delegate
extension ViewController: UIGestureRecognizerDelegate {
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            return
        }
        
        if(bombDiscovered) {
            return
        }
        
        let p = gestureReconizer.location(in: self.minesCollectionView)
        let indexPath = self.minesCollectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            var cell = self.minesCollectionView.cellForItem(at: index) as! mineCollectionViewCell
            
            //sets the flag if cell is not dicovered
            if !cell.isDiscoverd() {
                if cell.isFlag() {
                    bombsLeft += 1
                } else {
                    bombsLeft -= 1
                }
                minesLeftLabel.text = "Mines Left: \(bombsLeft)"
                cell.setFlag()
            }
            
        } else {
            print("Could not find index path")
        }
    }
}
