//
//  BookLineViewModeling.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 26/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import RxCocoa

protocol BasketLineViewModeling {
    var isbn: BehaviorRelay<String> { get }
    var quantity: BehaviorRelay<String> { get }
    var title: BehaviorRelay<String> { get }
    var price: BehaviorRelay<String> { get }
    var cover: BehaviorRelay<Data?> { get }
    init(with line: BasketLine)
    func deleteBasketLine(for basketId: Int, isbn: String)
}
