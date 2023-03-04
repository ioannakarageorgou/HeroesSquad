//
//  CharactersViewModelTests.swift
//  HeroesSquadTests
//
//  Created by Ioanna Karageorgou on 20/2/23.
//

import XCTest
@testable import HeroesSquad

final class CharactersViewModelTests: XCTestCase {

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
    var squad: [Character] = []
    var charactersViewModel: CharactersViewModel!

    @MainActor override func setUpWithError() throws {
        hero = heroes[0]
        let mockPersistenceService = PersistenceService(isInMemoryStore: true)
        self.charactersViewModel = CharactersViewModel(persistenceService: mockPersistenceService, superHeroes: heroes, squad: [])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTotalLoadedHeroes() async throws {
        let mockViewModelHeroes: [Character] = await charactersViewModel.superHeroes
        XCTAssertEqual(self.heroes.count, mockViewModelHeroes.count)
    }

    func testToggleSquadButtonForSquadMember() async throws {
        self.hero.isInSquad = true
        await charactersViewModel.toggleSquadFor(self.hero)
        let mockViewModelSquad: [Character] = await charactersViewModel.squad
        self.hero.isInSquad = false
        XCTAssertFalse(mockViewModelSquad.contains(self.hero))
    }

    func testToggleSquadButtonForNonSquadMember() async throws {
        self.hero.isInSquad = false
        await charactersViewModel.toggleSquadFor(self.hero)
        let mockViewModelSquad: [Character] = await charactersViewModel.squad
        XCTAssertTrue(mockViewModelSquad.contains(self.hero))
    }
    
    func testGetSquadMembers() async throws {
        await charactersViewModel.getSquadMembers()
        let prevMockViewModelSquad: [Character] = await charactersViewModel.squad
        self.hero.isInSquad = false
        await charactersViewModel.toggleSquadFor(self.hero)
        await charactersViewModel.getSquadMembers()
        let mockViewModelSquad: [Character] = await charactersViewModel.squad
        XCTAssertEqual(mockViewModelSquad.count, prevMockViewModelSquad.count + 1)
    }

    func testTriggerPaginationFailed() async throws {
        let expectedFalse = await charactersViewModel.canTriggerPagination(for: hero)
        XCTAssertFalse(expectedFalse)
    }
    
    func testTriggerPaginationSuccessful() async throws {
        let expectedTrue = await charactersViewModel.canTriggerPagination(for: heroes.last!)
        XCTAssertTrue(expectedTrue)
    }
}
