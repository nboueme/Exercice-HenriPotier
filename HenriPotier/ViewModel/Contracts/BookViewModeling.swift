//
//  BookCellViewModeling.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

protocol BookViewModeling {
    var isbn: BehaviorRelay<String> { get }
    var title: BehaviorRelay<String> { get }
    var price: BehaviorRelay<Double> { get }
    var cover: BehaviorRelay<URL?> { get }
    var synopsis: BehaviorRelay<String?> { get }
    
    init(with book: Book)
    init(isbn: String, title: String, price: Double, cover: URL?, synopsis: String?)
}
