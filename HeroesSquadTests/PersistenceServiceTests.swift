//
//  PersistenceServiceTests.swift
//  HeroesSquadTests
//
//  Created by Ioanna Karageorgou on 20/2/23.
//

import XCTest
@testable import HeroesSquad

final class PersistenceServiceTests: XCTestCase {
    
    var storage: PersistenceService!
    
    var heroes: [Character] {
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "SuccessHeroesJSON") else {
            XCTFail("Mock Generation Failed")
            fatalError()
        }
        
        var fetchedHeroes = [Character]()
        do {
            let response = try JSONDecoder().decode(CharactersResponse.self, from: mockData)
            fetchedHeroes = response.data.results
        } catch {
            XCTFail("JSON Decoding Failed")
        }
        return fetchedHeroes
    }
    
    var hero: Character!

    override func setUpWithError() throws {
        hero = heroes.randomElement()
        self.storage = PersistenceService(isInMemoryStore: true)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAllHeroInSquadAndCheckByName() throws {
        storage.insertSquadMember(character: hero, completion: {
            print("Inserted \(self.hero.name) into storage")
        })
        storage.fetch(SquadMember.self) { coreDataSquadHeroes in
            XCTAssertEqual(coreDataSquadHeroes.count, 1)
            XCTAssertEqual(coreDataSquadHeroes.first?.name, self.hero.name)
        }
    }
    
    func testIfHeroExistsInDatabase() throws {
        storage.insertSquadMember(character: hero, completion: {
            print("Inserted \(self.hero.name) into storage")
        })
        XCTAssertTrue(storage.squadMemberExists(with: Int32(hero.id)))
    }
    
    func testRemoveHeroFromSquad() throws {
        storage.insertSquadMember(character: hero, completion: {
            print("Inserted \(self.hero.name) into storage")
        })
        storage.removeSquadMember(with: self.hero.id) {
            print("Removed \(self.hero.name) from storage")
        }
        storage.fetch(SquadMember.self) { coreDataSquadHeroes in
            XCTAssertEqual(coreDataSquadHeroes.count, 0)
        }
    }

}
