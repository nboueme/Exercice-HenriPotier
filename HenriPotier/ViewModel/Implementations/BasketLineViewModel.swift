//
//  BasketLineViewModel.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 26/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

class BasketLineViewModel: BasketLineViewModeling {
    var isbn: BehaviorRelay<String>
    var quantity: BehaviorRelay<String>
    var title: BehaviorRelay<String>
    var price: BehaviorRelay<String>
    var cover: BehaviorRelay<Data?>
    
    required init(with line: BasketLine) {
        let quantityL10n = L10n.Basket.Cell.quantity(Int(line.quantity))
        quantity = BehaviorRelay(value: quantityL10n)
        
        let isbn = line.isbn ?? ""
        let book = BookEntity.find(byISBN: isbn)
        self.isbn = BehaviorRelay(value: isbn)
        
        title = BehaviorRelay(value: book?.title ?? "")
        cover = BehaviorRelay(value: book?.cover)

        let price = L10n.SelectedBook.price(Int(book?.price ?? 0))
        self.price = BehaviorRelay(value: price)
    }
}
