//
//  Book.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import Foundation

struct Book: Decodable {
    let isbn: String
    let title: String
    let price: Double
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
