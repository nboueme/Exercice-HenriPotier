//
//  Offer.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import Foundation

struct Offer: Decodable {
    var type: String
    var value: Int
    var sliceValue: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
        case sliceValue
    }
}

struct Offers: Decodable {
    var offers: [Offer]
    
    enum CodingKeys: String, CodingKey {
        case offers
    }
}
