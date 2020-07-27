//
//  Offer.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

struct CommercialOffer: Decodable {
    enum OfferType: Decodable {
        case percentage
        case minus
        case slice

        init(from decoder: Decoder) throws {
            let rawValue = try decoder.singleValueContainer().decode(String.self)
            switch rawValue {
            case "percentage":
                self = .percentage
            case "minus":
                self = .minus
            case "slice":
                self = .slice
            default:
                throw OfferError.unknownValue
            }
        }
    }

    var type: OfferType
    var value: Int
    var sliceValue: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case value
        case sliceValue
    }

    enum OfferError: Error {
        case unknownValue
    }
}

struct CommercialOffers: Decodable {
    var offers: [CommercialOffer]

    enum CodingKeys: String, CodingKey {
        case offers
    }
}
