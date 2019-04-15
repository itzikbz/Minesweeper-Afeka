//
//  GameLobyViewController.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 12/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//

import UIKit
import CoreData


class GameLobyViewController: UIViewController {
    var size = 0
    var mines = 0
    var difficulty = ""
    var pickerData = [String]()
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    
    //action for play button
    @IBAction func playButton(_ sender: Any) {
        //if nickname not valid show alrt
        if nicknameTextField.text == "" || (nicknameTextField.text?.count)! > 5 {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Nickname must be with 1-5 letters",
                                                    preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //Decide the game information according to the chosen difficulty
        switch picker.selectedRow(inComponent: 0) {
        case 0:
            size = 5
            mines = 5
            difficulty = "Easy"
            break
        case 1:
            size = 10
            mines = 20
            difficulty = "Normal"
            break
        case 2:
            size = 10
            mines = 25
            difficulty = "Hard"
            break
        default:
            return
        }
        
        //go to the game view
        performSegue(withIdentifier: "startGameSegue", sender: self)
    }
    

    
    //sets information and define delegate and datasoucr
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["Easy", "Normal", "Hard"]
    }
    
    //Prepare for game start segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if starts game - sets the information of the game
        if(segue.identifier == "startGameSegue") {
            let vc = segue.destination as! ViewController
            vc.size = size
            vc.mines = mines
            vc.nickname = nicknameTextField.text!
            vc.difficulty = difficulty
        }
    }
}

//extends the calss for the implmented delegate and data source functions
extension GameLobyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data itself
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
