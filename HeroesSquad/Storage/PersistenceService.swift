//
//  PersistenceService.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 19/2/23.
//

import Foundation
import CoreData

final class PersistenceService {
    
    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    init(isInMemoryStore: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "MarvelSquads")
        
        if isInMemoryStore {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
        
    func insertSquadMember(character: Character, completion: @escaping (() -> Void)) {
        if let squadMemberEntity = NSEntityDescription.insertNewObject(forEntityName: "SquadMember", into: context) as? SquadMember {
            let id = Int32(character.id)
            if !squadMemberExists(with: id) {
                squadMemberEntity.id = id
                squadMemberEntity.name = character.name
                squadMemberEntity.squadMemberDescription = character.description
                squadMemberEntity.imageUrl = "\(character.thumbnail.path).\(character.thumbnail.ext)"
                do {
                    try context.save()
                    completion()
                } catch let error as NSError {
                    print("Could not insert. \(error), \(error.userInfo)")
                }
            } else {
                print("squad member: \(character.name) already exists in database")
                completion()
            }
        }
    }
    
    func squadMemberExists(with id: Int32) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SquadMember")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        var count = 0
        do {
            count = try context.count(for: fetchRequest)
        } catch let error as NSError {
            print("error executing fetch request: \(error)")
            return false
        }
        return count > 0
    }
    
    func removeSquadMember(with id: Int, completion: @escaping (() -> Void)) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SquadMember")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        let characters = try! context.fetch(fetchRequest)
        for character in characters {
            context.delete(character)
        }
        do {
            try context.save()
            completion()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        
        do {
            let objects = try context.fetch(request)
            completion(objects)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion([])
        }
    }
    
}
