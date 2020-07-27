//
//  BasketEntity.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import CoreData

enum BasketState: String {
    case empty = "archivebox"
    case filled = "archivebox.fill"
}

struct BasketEntity {
    var basketId: Int
}

extension BasketEntity {
    private static func create(_ basketId: Int) {
        let basketContext = Basket(context: CoreDataManager.shared.viewContext)
        basketContext.id = Int16(basketId)
        
        saveContext()
    }
    
    private static func saveContext() {
        do {
            try CoreDataManager.shared.viewContext.save()
        } catch let error as NSError {
            print("error: \(error)")
        }
    }
    
    static func find(byId basketId: Int) -> Basket? {
        let request: NSFetchRequest<Basket> = Basket.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", basketId)
        request.fetchLimit = 1
        
        if let basket = try? CoreDataManager.shared.viewContext.fetch(request).first {
            return basket
        } else {
            create(basketId)
            return try? CoreDataManager.shared.viewContext.fetch(request).first
        }
    }
    
    static func addBasketLine(for basketId: Int, isbn: String, quantity: Int = 1) {
        if findBasketLine(for: isbn) == nil {
            let basket = find(byId: basketId)
            let basketLineContext = BasketLine(context: CoreDataManager.shared.viewContext)
            basketLineContext.book = BookEntity.find(byISBN: isbn)
            basketLineContext.quantity = Int16(quantity)
            basket?.addToLine(basketLineContext)
            saveContext()
        }
    }
    
    static func findBasketLine(for isbn: String) -> BasketLine? {
        guard let book = BookEntity.find(byISBN: isbn) else { return nil }
        
        let request: NSFetchRequest<BasketLine> = BasketLine.fetchRequest()
        request.predicate = NSPredicate(format: "book == %@", book)
        request.fetchLimit = 1
        
        return try? CoreDataManager.shared.viewContext.fetch(request).first
    }
}
