//
//  ShowTimeViewModel.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//

import Foundation
import CoreData

class ShowTimesViewModel: ObservableObject {
    @Published var showTimes: [ShowTime] = []
    private var managedObjectContext: NSManagedObjectContext
    private var loggedInUser: User 

    init(context: NSManagedObjectContext, user: User) {
        self.managedObjectContext = context
        self.loggedInUser = user
        loadShowTimes()
    }

    func loadShowTimes() {
        let fetchRequest: NSFetchRequest<ShowTime> = ShowTime.fetchRequest()
        do {
            showTimes = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch show times: \(error)")
        }
    }

    func buyTickets(showTime: ShowTime, numberOfTickets: Int) {
        for _ in 0..<numberOfTickets {
            let newTicket = Ticket(context: managedObjectContext)
            newTicket.showtime = showTime
            newTicket.user = loggedInUser
            showTime.addToTicket(newTicket)
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
