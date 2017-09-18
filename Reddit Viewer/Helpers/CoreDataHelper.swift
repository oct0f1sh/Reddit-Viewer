//
//  CoreData Helper.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/16/17.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    static func addSubreddit() -> Subreddit {
        let subreddit = NSEntityDescription.insertNewObject(forEntityName: "Subreddit", into: managedContext) as! Subreddit
        return subreddit
    }
    
    // I'm putting this in so I can commit
    
    static func saveSubreddit() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func deleteNote(subreddit: Subreddit) {
        managedContext.delete(subreddit)
        saveSubreddit()
    }
    
    static func retrieveSubreddits() -> [Subreddit] {
        let fetchRequest = NSFetchRequest<Subreddit>(entityName: "Subreddit")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
