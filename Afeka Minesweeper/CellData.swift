//
//  Mine.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 10/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//

import Foundation

class CellData{
    var imageName="blank_icon"
    var isMine=false
    var isFlag: Bool = false
    var isDiscoverd=false
    var nearbyMines: Int=0
}
