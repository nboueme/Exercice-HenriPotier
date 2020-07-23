//
//  BookStoreViewModeling.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

protocol BookStoreViewModeling {
    var service: BookService { get }
    var booksCells: BehaviorRelay<[BookViewModeling]> { get }
    func getBooksCells()
    
    init(service: BookService)
}
