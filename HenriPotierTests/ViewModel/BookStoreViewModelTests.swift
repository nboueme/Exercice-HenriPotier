//
//  HenriPotierTests.swift
//  HenriPotierTests
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import XCTest
import RxBlocking

@testable import Henri_Potier

class BookStoreViewModelTests: XCTestCase {
    var viewModel: BookStoreViewModeling!
    
    override func setUp() {
        super.setUp()
        CoreDataManager.shared.flushBooks()
        viewModel = BookStoreViewModel(service: BookService())
    }
    
    override func tearDown() {
        viewModel  = nil
        super.tearDown()
    }
    
    func test_booksInCoreDataShouldBeEmptyBeforeFetchingBooks() {
        XCTAssertEqual(BookEntity.all.isEmpty, true, "Books in Core Data should be empty.")
    }
    
    func test_booksInCoreDataShouldNotBeEmptyAfterFetchingBooks() throws {
        viewModel.getBooksCells()
        _ = try viewModel.booksCells.skip(1).toBlocking().first()
        XCTAssertEqual(BookEntity.all.isEmpty, false, "Books in Core Data should NOT be empty.")
        
    }
    
    func test_cellsShouldBeEmptyBeforeFetchingBooks() {
        XCTAssertEqual(viewModel.booksCells.value.isEmpty, true, "Books cells should be empty.")
    }

    func test_cellsShouldNotBeEmptyAfterFetchingBooks() throws {
        viewModel.getBooksCells()
        let cells = try viewModel.booksCells.skip(1).toBlocking().first()
        XCTAssertEqual(cells?.isEmpty, false, "Books cells should NOT be empty.")
    }
}
