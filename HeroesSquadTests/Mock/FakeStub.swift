//
//  FakeStub.swift
//  HeroesSquadTests
//
//  Created by Ioanna Karageorgou on 20/2/23.
//

import Foundation

class FakeStub {
    static func generateFakeDataFromJSONWith(fileName: String) -> Data? {
        let bundle = Bundle(for: FakeStub.self)
        let url = bundle.url(forResource: fileName, withExtension: "json")!
        return try? Data(contentsOf: url)
    }
}
