//
//  PersistenceService.swift
//  Minesweeper Afeka
//
//  Created by Itzik Ben Zakai on 13/04/2019.
//  Copyright © 2019 Itzik Ben Zakai. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    //Singletone object
    private init() {
    
    }
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "ScoresModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Get the scores from the database
    static func getUserScore() -> [PlayerScore] {
        let fetchRequest: NSFetchRequest<PlayerScore> = PlayerScore.fetchRequest()
        
        //descending score order
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var scores: [PlayerScore] = []
        do {
            scores = try PersistenceService.context.fetch(fetchRequest)
        } catch {
            print("Error retrieving the score list")
        }
        
        return scores
    }
}
