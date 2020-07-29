//
//  CoreDataManager.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import CoreData

public final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.containerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("error: \(error)")
        }
    }
}
