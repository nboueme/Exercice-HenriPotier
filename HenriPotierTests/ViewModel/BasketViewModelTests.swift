//
//  BasketViewModelTests.swift
//  HenriPotierTests
//
//  Created by Nicolas Bouème on 29/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import XCTest
import RxBlocking

@testable import Henri_Potier

class BasketViewModelTests: XCTestCase {
    var viewModel: BasketViewModeling!
    var basketID = Constant.basketID
    let isbnVol1 = "c8fabf68-8374-48fe-a7ea-a00ccd07afff"
    let isbnVol2 = "a460afed-e5e7-4e39-a39d-c885c05db861"
    
    override func setUp() {
        super.setUp()
        CoreDataManager.shared.flushBasket()
        viewModel = BasketViewModel(service: BookService())
    }
    
    override func tearDown() {
        viewModel  = nil
        super.tearDown()
    }
    
    func test_cellsShouldBeEmpty() {
        XCTAssertEqual(viewModel.basketLineCells.value.isEmpty, true, "Basket Lines cells should be empty.")
    }
    
    func test_cellsShouldNotBeEmpty() {
        viewModel.addBasketLine(for: basketID, isbn: isbnVol1)
        viewModel.getBasketLinesCells(for: basketID)
        XCTAssertEqual(viewModel.basketLineCells.value.isEmpty, false, "Basket Lines cells should NOT be empty.")
    }
    
    func test_bookIsAlreadyInBasket() {
        viewModel.addBasketLine(for: basketID, isbn: isbnVol1)
        viewModel.searchBasketLine(for: isbnVol1)
        XCTAssertFalse(viewModel.bookIsNotAlreadyInBasket.value, "The book should be in the basket.")
    }
    
    func test_bookIsNotAlreadyInBasket() {
        viewModel.searchBasketLine(for: isbnVol1)
        XCTAssertTrue(viewModel.bookIsNotAlreadyInBasket.value, "The book should NOT be in the basket.")
    }
    
    func test_basketIconIsEmptyState() {
        let iconName = BasketState.empty.rawValue
        XCTAssertEqual(viewModel.basketIconName.value, iconName, "Basket icon should be named: \(iconName)")
    }
    
    func test_basketIconIsFilledState() {
        viewModel.addBasketLine(for: basketID, isbn: isbnVol1)
        let iconName = BasketState.filled.rawValue
        XCTAssertEqual(viewModel.basketIconName.value, iconName, "Basket icon should be named: \(iconName)")
    }
    
    func test_basketAmountBeforeOffer() {
        viewModel.addBasketLine(for: basketID, isbn: isbnVol1)
        viewModel.addBasketLine(for: basketID, isbn: isbnVol2)
        viewModel.getTotalPrice(for: basketID)
        XCTAssertEqual(viewModel.finalPriceWithoutOffer.value.string, "65.00€", "Final price without offer should be equal to 65.00€")
    }
    
    func test_basketAmountAfterOffer() throws {
        viewModel.addBasketLine(for: basketID, isbn: isbnVol1)
        viewModel.addBasketLine(for: basketID, isbn: isbnVol2)
        viewModel.getTotalPrice(for: basketID)
        
        let finalPrice = try viewModel.finalPriceWithOffer.skip(1).toBlocking().first()
        XCTAssertEqual(finalPrice?.string, "50.00€", "Final price with offer should be equal to 50.00€")
    }
    
    func test_basketOfferTypeShouldBePercentage() {
        let requestExpectation = expectation(description: "Alamofire")
        
        let basketAmount = BookEntity.find(byISBN: isbnVol1)!.price
        
        var reduction: [CommercialOffer.OfferType: Float] = [:]
        
        viewModel.service.fetchOffers(for: isbnVol1) { data in
            try? data.get().offers.forEach { offer in
                reduction[offer.type] = offer.getReduction(for: basketAmount)
            }
            
            requestExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        let bestOffer = reduction.filter { $1 == reduction.values.min() }.first
        XCTAssertEqual(bestOffer?.key, CommercialOffer.OfferType.percentage, "Best offer type should be percentage.")
    }
    
    func test_basketOfferTypeShouldBeMinus() {
        let requestExpectation = expectation(description: "Alamofire")
        
        let priceVol1 = BookEntity.find(byISBN: isbnVol1)!.price
        let priceVol2 = BookEntity.find(byISBN: isbnVol2)!.price
        let basketAmount = priceVol1 + priceVol2
        
        var reduction: [CommercialOffer.OfferType: Float] = [:]
        
        viewModel.service.fetchOffers(for: isbnVol1, isbnVol2) { data in
            try? data.get().offers.forEach { offer in
                reduction[offer.type] = offer.getReduction(for: basketAmount)
            }
            
            requestExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        let bestOffer = reduction.filter { $1 == reduction.values.min() }.first
        XCTAssertEqual(bestOffer?.key, CommercialOffer.OfferType.minus, "Best offer type should be minus.")
    }
    
    func test_basketOfferTypeShouldBeSlice() {
        let requestExpectation = expectation(description: "Alamofire")
        
        let priceVol1 = BookEntity.find(byISBN: isbnVol1)!.price
        var basketAmount: Float = 0
        var isbnArray = [String]()
        
        for _ in 1...7 {
            basketAmount += priceVol1
            isbnArray.append(isbnVol1)
        }
        
        var reduction: [CommercialOffer.OfferType: Float] = [:]
        
        viewModel.service.fetchOffers(for: isbnArray.joined(separator: ",")) { data in
            try? data.get().offers.forEach { offer in
                reduction[offer.type] = offer.getReduction(for: basketAmount)
            }
            
            requestExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        let bestOffer = reduction.filter { $1 == reduction.values.min() }.first
        XCTAssertEqual(bestOffer?.key, CommercialOffer.OfferType.slice, "Best offer type should be slice.")
    }
}
