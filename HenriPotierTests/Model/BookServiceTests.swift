//
//  BookServiceTest.swift
//  HenriPotierTests
//
//  Created by Nicolas Bouème on 29/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import XCTest

@testable import Henri_Potier

class BookServiceTests: XCTestCase {
    var service: BookService!
    var expectation: XCTestExpectation!
    let isbnVol1 = "c8fabf68-8374-48fe-a7ea-a00ccd07afff"
    let isbnVol2 = "a460afed-e5e7-4e39-a39d-c885c05db861"
    
    override func setUp() {
        super.setUp()
        service = BookService()
        expectation = expectation(description: "Alamofire")
    }
    
    override func tearDown() {
        service = nil
        expectation = nil
        super.tearDown()
    }
    
    func test_booksShouldBeFetched() {
        var books: [BookEntity] = []
        
        service.fetchBooks { data in
            do {
                books = try data.get()
            } catch {
                books = []
            }
            
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(books.isEmpty, false, "Books should NOT be empty.")
        XCTAssertEqual(books.count, 7, "Array's size should be equal to 7.")
    }

    func test_basketOfferShouldBeFetched() {
        var offers: [CommercialOffer] = []
        
        service.fetchOffers(for: isbnVol1, isbnVol2) { data in
            do {
                offers = try data.get().offers
            } catch {
                offers = []
            }
            
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(offers.isEmpty, false, "Offers should NOT be empty.")
        XCTAssertEqual(offers.count, 3, "Array's size should be equal to 3.")
    }
}
