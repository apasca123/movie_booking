//
//  UserViewModel.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//

import Foundation
import CryptoKit
import CoreData

class UsersViewModel: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }

    func addUser(username: String, password: String, email: String) {
        let hashedPassword = CryptPassUtils.encryptPassword(input: password);
        let newUser = User(context: managedObjectContext)
        newUser.username = username
        newUser.password = hashedPassword
        newUser.email = email

        saveContext();
    }

    func authenticateUser(username: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if let user = results.first {
                return CryptPassUtils.encryptPassword(input: password) == user.password;
            }
            return false;
        } catch {
            print("Authentication error: \(error)")
            return false;
        }
    }
    
    func logoutUser() {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "loggedInUsername")
    }

    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save user: \(error)")
        }
    }
}
