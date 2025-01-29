//
//  User+CoreDataProperties.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 28.01.2025.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userID: UUID?
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?
    @NSManaged public var dateCreated: Date?

}

extension User : Identifiable {

}
