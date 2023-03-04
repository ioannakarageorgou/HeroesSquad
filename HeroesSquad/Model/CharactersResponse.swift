//
//  CharactersResponse.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 17/2/23.
//

import Foundation

struct CharactersResponse: Decodable {
    let data: CharactersResponseData
}

struct CharactersResponseData: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let results: [Character]
}
