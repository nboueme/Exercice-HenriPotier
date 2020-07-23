//
//  NetworkLayer.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import Alamofire

typealias FetchDecodable<T: Decodable> = (Result<T, Error>) -> Void

class NetworkLayer {
    private var slash = "/"
    
    func getCompleteURL(_ args: String...) -> String {
        return args.joined(separator: slash)
    }
    
    func fetchRequest<T: Decodable>(with URL: String, mapTo decodable: T.Type, _ completion: @escaping(FetchDecodable<T>)) {
        AF.request(URL, method: .get)
            .validate()
            .responseDecodable(of: decodable) { response in
                guard let data = response.value else { return }
                completion(.success(data))
        }
    }
}
