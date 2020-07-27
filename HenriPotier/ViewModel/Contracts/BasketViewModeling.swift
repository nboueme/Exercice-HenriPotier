//
//  BasketViewModeling.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

protocol BasketViewModeling {
    var service: BookService { get }
    var basketLineCells: BehaviorRelay<[BasketLineViewModeling]> { get }
    var bookIsNotAlreadyInBasket: BehaviorRelay<Bool> { get }
    var basketIconName: BehaviorRelay<String> { get }
    var finalPriceWithoutOffer: BehaviorRelay<NSAttributedString> { get }
    var finalPriceWithOffer: BehaviorRelay<NSAttributedString> { get }
    func searchBasketLine(for isbn: String)
    func deleteLine(for isbn: String)
    init(service: BookService)
}

extension BasketViewModeling {
    func addBasketLine(for basketId: Int, isbn: String, quantity: Int = 1) {
        BasketEntity.addBasketLine(for: basketId, isbn: isbn, quantity: quantity)
        bookIsNotAlreadyInBasket.accept(false)
        basketIconName.accept("archivebox.fill")
    }
}
