//
//  BookService.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

typealias FetchBooks = (Result<[BookEntity], Error>) -> Void
typealias FetchOffers = (Result<Offers, Error>) -> Void

final class BookService: NetworkLayer {
    private var baseURL = "http://henri-potier.xebia.fr"
    
    private enum Path: String {
        case books
        case commercialOffers
    }
}

extension BookService {
    func fetchBooks(completion: @escaping(FetchBooks)) {
        let completeURL = getCompleteURL(baseURL, Path.books.rawValue)
        fetchRequest(with: completeURL, mapTo: [BookEntity].self, completion)
    }
    
    func fetchOffers(for ISBN: String..., completion: @escaping(FetchOffers)) {
        let completeURL = getCompleteURL(baseURL, Path.books.rawValue, ISBN.joined(separator: ","), Path.commercialOffers.rawValue)
        fetchRequest(with: completeURL, mapTo: Offers.self, completion)
    }
}
