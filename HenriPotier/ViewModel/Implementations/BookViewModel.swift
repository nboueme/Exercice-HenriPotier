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
    var synopsis: BehaviorRelay<NSAttributedString>
    
    required init(with book: Book) {
        self.isbn = BehaviorRelay(value: book.isbn ?? "")
        self.title = BehaviorRelay(value: book.title ?? "")
        self.cover = BehaviorRelay(value: book.cover)
        
        let price = L10n.SelectedBook.price(book.price)
        self.price = BehaviorRelay(value: price)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.hyphenationFactor = 1
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        let text = book.synopsis ?? ""
        let synopsis = NSAttributedString(string: text, attributes: attributes)
        self.synopsis = BehaviorRelay(value: synopsis)
    }
    
    required init(isbn: String) {
        let book = BookEntity.find(byISBN: isbn)
        
        self.isbn = BehaviorRelay(value: book?.isbn ?? "")
        self.title = BehaviorRelay(value: book?.title ?? "")
        self.cover = BehaviorRelay(value: book?.cover)
        
        let price = L10n.SelectedBook.price(book?.price ?? 0)
        self.price = BehaviorRelay(value: price)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.hyphenationFactor = 1
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        let text = book?.synopsis ?? ""
        let synopsis = NSAttributedString(string: text, attributes: attributes)
        self.synopsis = BehaviorRelay(value: synopsis)
    }
}
