//
//  CharactersViewModelError.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 20/2/23.
//

import Foundation

enum CharactersViewModelError: GenericErrorEnum {
    var id: Self { self }

    case noInternetConnection
    case couldNotUpdateHero
    case internalServiceError
    case unknown

    var title: String {
        switch self {
        case .noInternetConnection:
            return "No Internet Connection"
        default:
            return "Error"
        }
    }

    var errorDescription: String {
        switch self {
        case .couldNotUpdateHero:
            return "Heroes ψould not be updated"
        case .noInternetConnection:
            return "Please enable Wifi or Cellular data"
        case .internalServiceError:
            return "An internal service error has occurred"
        case .unknown:
            return "An error has occurred"
        }
    }
}
