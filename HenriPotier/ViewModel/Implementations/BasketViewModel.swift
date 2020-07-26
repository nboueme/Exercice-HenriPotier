//
//  BasketViewModel.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

class BasketViewModel: BasketViewModeling {
    var basketLineCells = BehaviorRelay<[BasketLineViewModeling]>(value: [])
    var bookIsNotAlreadyInBasket = BehaviorRelay<Bool>(value: true)
    var basketIconName = BehaviorRelay<String>(value: BasketState.empty.rawValue)
    
    private var basketId = 0
    
    required init() {
        getBasketSize(for: basketId)
        getBasketLinesCells(for: basketId)
    }
    
    func searchBasketLine(for isbn: String) {
        let isNotAlreadyInBasket = BasketEntity.findBasketLine(for: isbn) == nil ? true : false
        bookIsNotAlreadyInBasket.accept(isNotAlreadyInBasket)
    }
}

extension BasketViewModel {
    private func getBasketSize(for basketId: Int) {
        let basket = BasketEntity.find(byId: basketId)
        let basketLines = basket?.line?.allObjects as? [BasketLine]
        let basketSize = basketLines?.count ?? 0
        let iconName = basketSize > 0 ?
                BasketState.filled.rawValue :
                BasketState.empty.rawValue
        basketIconName.accept(iconName)
    }
    
    private func getBasketLinesCells(for basketId: Int) {
        guard let basket = BasketEntity.find(byId: basketId) else { return }
        guard let basketLines = basket.line?.allObjects as? [BasketLine] else { return }
        
        let cells = basketLines.map { BasketLineViewModel(with: $0) } as [BasketLineViewModeling]
        basketLineCells.accept(cells)
    }
}
