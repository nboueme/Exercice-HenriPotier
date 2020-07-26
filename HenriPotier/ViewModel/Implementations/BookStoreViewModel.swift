//
//  BookStoreViewModel.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

class BookStoreViewModel: BookStoreViewModeling {
    internal var service: BookService
    var booksCells = BehaviorRelay<[BookViewModeling]>(value: [])
    
    required init(service: BookService) {
        self.service = service
    }
    
    func getBooksCells() {
        service.fetchBooks { [weak self] data in
            guard let strongSelf = self else { return }
            guard let books = try? data.get() else { return }
            
            BookEntity.save(books)
            
            let cells = BookEntity.all.map { BookViewModel(with: $0) } as [BookViewModeling]
            strongSelf.booksCells.accept(cells)
        }
    }
}
