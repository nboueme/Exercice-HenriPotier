//
//  BasketViewModeling.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

protocol BasketViewModeling {
    var basketLineCells: BehaviorRelay<[BasketLineViewModeling]> { get }
    var bookIsNotAlreadyInBasket: BehaviorRelay<Bool> { get }
    var basketIconName: BehaviorRelay<String> { get }
    func searchBasketLine(for isbn: String)
    init()
}

extension BasketViewModeling {
    func addBasketLine(for basketId: Int, isbn: String, quantity: Int = 1) {
        BasketEntity.addBasketLine(for: basketId, isbn: isbn, quantity: quantity)
        bookIsNotAlreadyInBasket.accept(false)
        basketIconName.accept("archivebox.fill")
    }
}
