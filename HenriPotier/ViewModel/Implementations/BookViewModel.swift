//
//  BookCellViewModel.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

class BookViewModel: BookViewModeling {
    var isbn: BehaviorRelay<String>
    var title: BehaviorRelay<String>
    var price: BehaviorRelay<Double>
    var cover: BehaviorRelay<URL?>
    var synopsis: BehaviorRelay<String?>
    
    required init(with book: Book) {
        isbn = BehaviorRelay(value: book.isbn)
        title = BehaviorRelay(value: book.title)
        price = BehaviorRelay(value: book.price)
        
        let coverURL = book.cover != nil ? URL(string: book.cover!) : nil
        cover = BehaviorRelay(value: coverURL)
        
        synopsis = BehaviorRelay(value: book.synopsis?.joined(separator: "\n\n"))
    }
    
    required init(isbn: String, title: String, price: Double, cover: URL?, synopsis: String?) {
        self.isbn = BehaviorRelay(value: isbn)
        self.title = BehaviorRelay(value: title)
        self.price = BehaviorRelay(value: price)
        self.cover = BehaviorRelay(value: cover)
        self.synopsis = BehaviorRelay(value: synopsis)
    }
}
