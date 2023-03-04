//
//  CharactersViewModel.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 18/2/23.
//

import Foundation
import Combine

@MainActor
class CharactersViewModel: ObservableObject {
    
    @Published private(set) var superHeroes: [Character]
    @Published private(set) var squad: [Character]
    @Published var viewModelError: CharactersViewModelError?
    
    private var heroesPublisher: AnyCancellable?
    
    private var networkService: NetworkService {
        return NetworkService()
    }
    
    private var persistenceService: PersistenceService!
    
    init(persistenceService: PersistenceService = PersistenceService(), superHeroes: [Character] = [], squad: [Character] = []) {
        self.persistenceService = PersistenceService()
        self.superHeroes = superHeroes
        self.squad = squad
    }
        
    var offset: Int = 0
    var limit: Int = 30
    
    func loadCharacters() {
        heroesPublisher = networkService.getCharacters(offset, limit).receive(on: DispatchQueue.main).sink { [weak self] completion in
            if case .failure(let error) = completion {
                print("error: \(error.localizedDescription)")
                switch error {
                case .noInternetConnection:
                    self?.viewModelError = .noInternetConnection
                default:
                    self?.viewModelError = .internalServiceError
                }
            }
        } receiveValue: { [weak self] heroes in
            var tempHeroes = heroes
            self?.getSquadMembers()
            for h in self!.squad {
                let heroIndex = tempHeroes.indices.filter { tempHeroes[$0].id == h.id }.first
                if let safeIndex = heroIndex {
                    tempHeroes[safeIndex].isInSquad = true
                }
            }
            self?.superHeroes.append(contentsOf: tempHeroes)
            self?.offset += self?.limit ?? 0
        }
    }
    
    func toggleSquadFor(_ hero: Character) async {
        print("TOGGLE BUTTON: isInSquad = \(hero.isInSquad)")
        let heroIndex = superHeroes.indices.filter { superHeroes[$0].id == hero.id }.first
        if let safeIndex = heroIndex {
            let updatedIsInSquad = !hero.isInSquad
            superHeroes[safeIndex].isInSquad = updatedIsInSquad
            let heroToUpdate = superHeroes[safeIndex]
            if updatedIsInSquad {
                persistenceService.insertSquadMember(character: heroToUpdate, completion: {
                    print("Inserted \(heroToUpdate.name) into storage")
                    self.squad.append(heroToUpdate)
                    print("Inserted \(heroToUpdate.name) to squad array ")
                })
            } else {
                persistenceService.removeSquadMember(with: heroToUpdate.id, completion: {
                    print("Removed \(heroToUpdate.name) from storage")
                    if let index = self.squad.firstIndex(of: heroToUpdate) {
                        self.squad.remove(at: index)
                        print("Removed \(heroToUpdate.name) from squad array (at index: \(index)")
                    }
                })
            }
        } else {
            self.viewModelError = .couldNotUpdateHero
        }
    }
    
    func getSquadMembers() {
        persistenceService.fetch(SquadMember.self) { squadMembers in
            print("retrieved \(squadMembers.count) squad members")
            var updatedSquad: [Character] = []
            for squadMember in squadMembers {
                var path = ""
                var ext = ""
                if let imageUrl = squadMember.imageUrl {
                    let lastFullStop = imageUrl.lastIndex(of: ".")!
                    path = String(imageUrl[imageUrl.startIndex..<lastFullStop])
                    ext = String(String(imageUrl[lastFullStop..<imageUrl.endIndex]).dropFirst())
                }
                let thumbnail = Thumbnail(path: path, ext: ext)
                updatedSquad.append(Character(id: Int(squadMember.id),
                                              name: squadMember.name ?? "No Name Found",
                                              description: squadMember.squadMemberDescription!,
                                              thumbnail: thumbnail,
                                              isInSquad: true))
            }
            self.squad = updatedSquad
        }
    }
    
    func canTriggerPagination(for hero: Character) -> Bool {
        return superHeroes.count > 0 && superHeroes.last == hero ? true : false
    }
    
    func togglePagination() async {
        print("togglePagination")
        if superHeroes.count > limit - 1 {
            loadCharacters()
        }
    }
}
