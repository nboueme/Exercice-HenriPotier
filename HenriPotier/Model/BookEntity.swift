//
//  Book.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import CoreData

struct BookEntity: Decodable {
    let isbn: String
    let title: String
    let price: Float
    let cover: String?
    let synopsis: [String]?
    
    enum CodingKeys: String, CodingKey {
        case isbn
        case title
        case price
        case cover
        case synopsis
    }
}

extension BookEntity {
    static func save(_ books: [BookEntity]) {
        books.forEach { book in
            save(book)
        }
    }
    
    private static func save(_ book: BookEntity) {
        guard find(byISBN: book.isbn) == nil else { return }
        
        let bookContext = Book(context: CoreDataManager.shared.viewContext)
        bookContext.isbn = book.isbn
        bookContext.title = book.title
        bookContext.price = book.price
        bookContext.synopsis = book.synopsis?.joined(separator: "\n\n")
        
        if
            let cover = book.cover,
            let coverURL = URL(string: cover),
            let data = try? Data.init(contentsOf: coverURL) {
            bookContext.cover = data
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    static var all: [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        guard let books = try? CoreDataManager.shared.viewContext.fetch(request) else { return [] }
        return books
    }
    
    static func find(byISBN isbn: String) -> Book? {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.predicate = NSPredicate(format: "isbn == %@", isbn)
        request.fetchLimit = 1
        
        return try? CoreDataManager.shared.viewContext.fetch(request).first
    }
}
