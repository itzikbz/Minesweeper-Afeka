//
//  MinesModel.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 10/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//

import Foundation

class MinesModel {
    
    func getMineArray(size: Int, mines: Int) -> [[CellData]] {
        var mineArray = [[CellData]]()
        
        //Init the mines array
         for _ in 0...size - 1 {
            var mineRow = [CellData]()
            for _ in 0...size - 1 {
                mineRow.append(CellData())
            }
            mineArray.append(mineRow)
        }
        
        //Set the bombs randomly
        var minesLeft = mines
        while minesLeft > 0 {
            let rowNumber = Int.random(in: 0 ..< size)
            let colNumber = Int.random(in: 0 ..< size)
            if mineArray[rowNumber][colNumber].isMine == false {
                mineArray[rowNumber][colNumber].isMine = true
                minesLeft = minesLeft - 1
            }
        }
        
        //Count nearby mines for all cells
        for i in 0...size - 1 {
            for j in 0...size - 1{
                if mineArray[i][j].isMine {
                    if i > 0 {
                        mineArray[i-1][j].nearbyMines = mineArray[i-1][j].nearbyMines + 1
                        if j > 0 {
                             mineArray[i-1][j-1].nearbyMines = mineArray[i-1][j-1].nearbyMines + 1
                        }
                        if j < size - 1 {
                             mineArray[i-1][j+1].nearbyMines = mineArray[i-1][j+1].nearbyMines + 1
                        }
                    }
                    
                    if i < size - 1 {
                        mineArray[i+1][j].nearbyMines = mineArray[i+1][j].nearbyMines + 1
                        if j > 0 {
                            mineArray[i+1][j-1].nearbyMines = mineArray[i+1][j-1].nearbyMines + 1
                        }
                        if j < size - 1 {
                            mineArray[i+1][j+1].nearbyMines = mineArray[i+1][j+1].nearbyMines + 1
                        }
                    }
                    
                    if j > 0 {
                        mineArray[i][j-1].nearbyMines = mineArray[i][j-1].nearbyMines + 1
                    }
                    if j < size - 1 {
                          mineArray[i][j+1].nearbyMines = mineArray[i][j+1].nearbyMines + 1
                    }
                    
                }
            }
        }
        
        //Sets the image for each cell
        for i in 0..<size {
            for j in 0..<size {
                if(mineArray[i][j].isMine) {
                    mineArray[i][j].imageName = "bomb"
                } else {
                mineArray[i][j].imageName = "icon\(mineArray[i][j].nearbyMines)"
                }
            }
        }
        return mineArray
    }
    

}
