//
//  SquadMember Properties.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 19/2/23.
//

import Foundation
import CoreData


extension SquadMember {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SquadMember> {
        return NSFetchRequest<SquadMember>(entityName: "SquadMember")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var squadMemberDescription: String?
    @NSManaged public var imageUrl: String?
}
