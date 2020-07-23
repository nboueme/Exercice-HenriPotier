//
//  BookStoreViewModel.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

class BookStoreViewModel: BookStoreViewModeling {
    var booksCells = BehaviorRelay<[BookViewModeling]>(value: [])
    
    func getBooksCells() {
        let cells: [BookViewModeling] = BookStore
            .bookStoreDataSource
            .map { BookViewModel(with: $0) }
        
        booksCells.accept(cells)
    }
}
