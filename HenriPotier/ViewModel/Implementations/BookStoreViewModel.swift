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
        service.fetchOffers(for: "c8fabf68-8374-48fe-a7ea-a00ccd07afff", "a460afed-e5e7-4e39-a39d-c885c05db861") { data in
            guard let data = try? data.get() else { return }
            print(data.offers)
        }
        
        service.fetchBooks { [weak self] books in
            guard let strongSelf = self else { return }
            guard let books = try? books.get() else { return }
            
            let cells = books.map { BookViewModel(with: $0) } as [BookViewModeling]
            strongSelf.booksCells.accept(cells)
        }
    }
}
