//
//  CoreDataManager+Extension.swift
//  HenriPotierTests
//
//  Created by Nicolas Bouème on 29/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

@testable import Henri_Potier

extension CoreDataManager {
    func flushBooks() {
        for book in BookEntity.all {
            viewContext.delete(book)
        }
        saveContext()
    }
    
    func flushBasket() {
        guard let basket = BasketEntity.find(byId: Constant.basketID) else { return }
        viewContext.delete(basket)
        saveContext()
    }
}
