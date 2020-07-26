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
    var price: BehaviorRelay<String>
    var cover: BehaviorRelay<Data?>
    var synopsis: BehaviorRelay<String?>
    
    required init(with book: Book) {
        isbn = BehaviorRelay(value: book.isbn ?? "")
        title = BehaviorRelay(value: book.title ?? "")
        
        let price = L10n.SelectedBook.price(Int(book.price))
        self.price = BehaviorRelay(value: price)
        
        cover = BehaviorRelay(value: book.cover)
        synopsis = BehaviorRelay(value: book.synopsis)
    }
    
    required init(isbn: String) {
        let book = BookEntity.find(byISBN: isbn)
        
        self.isbn = BehaviorRelay(value: book?.isbn ?? "")
        self.title = BehaviorRelay(value: book?.title ?? "")
        
        let price = L10n.SelectedBook.price(Int(book?.price ?? 0))
        self.price = BehaviorRelay(value: price)
        
        self.cover = BehaviorRelay(value: book?.cover)
        self.synopsis = BehaviorRelay(value: book?.synopsis)
    }
}
