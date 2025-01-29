//
//  SessionManager.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//

import Foundation
import CoreData
import Combine

class SessionManager: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    @Published var currentUser: User?
    private var managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        loadCurrentUser()
    }

    func loadCurrentUser() {
        guard let username = UserDefaults.standard.string(forKey: "loggedInUsername") else {
            print("No logged-in user found.")
            return
        }

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)

        do {
            let users = try managedObjectContext.fetch(request)
            if let user = users.first {
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isUserLoggedIn = true;
                }
            } else {
                print("User not found in Core Data.")
            }
        } catch {
            print("Error fetching current user: \(error)")
        }
    }


    func loginUser(username: String) {
        DispatchQueue.main.async {
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(username, forKey: "loggedInUsername")
            self.isUserLoggedIn = true
        }
    }

    func logoutUser() {
        DispatchQueue.main.async {
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.removeObject(forKey: "loggedInUserID")
            self.isUserLoggedIn = false
            self.currentUser = nil
        }
    }
    
    func checkLoginStatus() {
        DispatchQueue.main.async {
            self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
            if self.isUserLoggedIn {
                self.loadCurrentUser()
            }
        }
    }
}
