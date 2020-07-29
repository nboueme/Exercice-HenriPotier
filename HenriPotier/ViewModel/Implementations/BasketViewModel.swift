//
//  BasketViewModel.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

class BasketViewModel: BasketViewModeling {
    var service: BookService
    var basketLineCells = BehaviorRelay<[BasketLineViewModeling]>(value: [])
    var bookIsNotAlreadyInBasket = BehaviorRelay<Bool>(value: true)
    var basketIconName = BehaviorRelay<String>(value: BasketState.empty.rawValue)
    var finalPriceWithoutOffer = BehaviorRelay<NSAttributedString>(value: NSAttributedString(string: L10n.Basket.sumBeforeOffer(0)))
    var finalPriceWithOffer = BehaviorRelay<NSAttributedString>(value: NSAttributedString(string: L10n.Basket.sumAfterOffer(0)))
    
    private var basketId = Constant.basketID
    
    required init(service: BookService) {
        self.service = service
        getBasketSize(for: basketId)
        getBasketLinesCells(for: basketId)
        getTotalPrice(for: basketId)
    }
    
    func getBasketLinesCells(for basketId: Int) {
        let cells = getBasketLines(for: basketId)
            .map { BasketLineViewModel(with: $0) } as [BasketLineViewModeling]
        basketLineCells.accept(cells)
    }
    
    func searchBasketLine(for isbn: String) {
        let isNotAlreadyInBasket = BasketEntity.findBasketLine(for: isbn) == nil ? true : false
        bookIsNotAlreadyInBasket.accept(isNotAlreadyInBasket)
    }
    
    func getTotalPrice(for basketId: Int) {
        var basketAmount: Float = 0
        var booksISBN = [String]()
        
        getBasketLines(for: basketId).forEach { line in
            guard let book = line.book else { return }
            basketAmount += book.price
            booksISBN.append(book.isbn ?? "")
        }
        
        getTotalPriceBeforeOffer(for: basketAmount)
        getTotalPriceAfterOffer(for: basketAmount, and: booksISBN)
    }
}

extension BasketViewModel {
    private func getBasketLines(for basketId: Int) -> [BasketLine] {
        guard let basket = BasketEntity.find(byId: basketId) else { return [] }
        guard let basketLines = basket.line?.allObjects as? [BasketLine] else { return [] }
        return basketLines
    }
    
    private func getBasketSize(for basketId: Int) {
        let basketSize = getBasketLines(for: basketId).count
        let iconName = basketSize > 0 ?
                BasketState.filled.rawValue :
                BasketState.empty.rawValue
        basketIconName.accept(iconName)
    }
    
    private func getTotalPriceBeforeOffer(for basketAmount: Float) {
        let attributes: [NSAttributedString.Key: Any] = [.strikethroughStyle: 2]
        let text = L10n.Basket.sumBeforeOffer(basketAmount)
        finalPriceWithoutOffer.accept(NSAttributedString(string: text, attributes: attributes))
    }
    
    private func getTotalPriceAfterOffer(for basketAmount: Float, and booksISBN: [String]) {
        var prices: [Float] = []
        
        service.fetchOffers(for: booksISBN.joined(separator: ",")) { data in
            guard let data = try? data.get() else { return }
            data.offers.forEach { offer in
                switch offer.type {
                case .percentage:
                    prices.append(basketAmount - basketAmount * Float(offer.value) / 100)
                case .minus:
                    prices.append(basketAmount - Float(offer.value))
                case .slice:
                    guard let sliceValue = offer.sliceValue else { break }
                    prices.append(basketAmount - Float(Int(basketAmount) / sliceValue * offer.value))
                }
            }
            
            let text = L10n.Basket.sumAfterOffer(prices.min() ?? 0)
            self.finalPriceWithOffer.accept(NSAttributedString(string: text))
        }
    }
}
