//
//  NetworkService.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 18/2/23.
//

import Foundation
import Combine

enum NetworkError: Error, Equatable {
    case noInternetConnection
    case invalidURL
    case url(error: URLError)
    case decoder(error: Error)
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

protocol NetworkServiceProtocol {
    func getCharacters(_ offset: Int, _ limit: Int) -> AnyPublisher<[Character], NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    
    struct MarvelAPIConstants {
        static let publicKey = "71e742407ca8b4ac76c4917a1c199a09"
        static let privateKey = "67a407d72945a9b1ee019145174ae42a02b7117d"
    }
    
    private var sharedSession: URLSession {
        return URLSession.shared
    }
    
    private var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
    func getCharacters(_ offset: Int = 0, _ limit: Int = 20) -> AnyPublisher<[Character], NetworkError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.path = "/v1/public/characters"
        let timeStamp = Int(Date().timeIntervalSince1970)
        let hash = "\(timeStamp)\(MarvelAPIConstants.privateKey)\(MarvelAPIConstants.publicKey)".md5

        components.queryItems = [
            .init(name: "limit", value: String(limit)),
            .init(name: "offset", value: String(offset)),
            .init(name: "apikey", value: MarvelAPIConstants.publicKey),
            .init(name: "ts", value: String(timeStamp)),
            .init(name: "hash", value: hash)
        ]
        
        guard let url = components.url else {
            return Fail<[Character], NetworkError>(error: .invalidURL)
                .eraseToAnyPublisher()
        }
        
        return sharedSession
            .dataTaskPublisher(for: URLRequest(url: url))
            .mapError {
                (networkError: URLError) -> NetworkError in
                if nil != networkError.networkUnavailableReason {
                    return NetworkError.noInternetConnection
                }
                return NetworkError.url(error: networkError)
            }
            .map { $0.data }
            .decode(type: CharactersResponse.self, decoder: decoder)
            .mapError { rr in
                print(rr.localizedDescription)
                return NetworkError.decoder(error: rr)
            }
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
}
