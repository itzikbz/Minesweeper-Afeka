//
//  PlayerScore+CoreDataProperties.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 13/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//
//

import Foundation
import CoreData


extension PlayerScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerScore> {
        return NSFetchRequest<PlayerScore>(entityName: "PlayerScore")
    }

    @NSManaged public var name: String?
    @NSManaged public var score: Double
    @NSManaged public var difficulty: String?

}
