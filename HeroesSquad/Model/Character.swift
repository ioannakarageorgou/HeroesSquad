//
//  Character.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 17/2/23.
//

import Foundation

struct Character: Decodable, Identifiable, Comparable {
    
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
    
    var isInSquad: Bool = false
    
    var imageUrl: URL? {
        return thumbnail.completeURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail
    }
    
    static func < (lhs: Character, rhs: Character) -> Bool {
        lhs.name < rhs.name
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}

struct Thumbnail: Decodable {
    let path: String
    let ext: String
    
    var completeURL: URL? {
        return URL(string: path + "." + self.ext)
    }
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}
