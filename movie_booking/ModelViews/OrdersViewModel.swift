import Foundation
import SwiftUICore
import CoreData

class OrdersViewModel: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext
    private var sessionManager: SessionManager
    @Published var orders: [Order] = []
    @Published var tickets: [Ticket] = []

    init(context: NSManagedObjectContext, sessionManager: SessionManager) {
        self.managedObjectContext = context
        self.sessionManager = sessionManager
    }

    func loadOrders() {
        guard sessionManager.isUserLoggedIn, let username = UserDefaults.standard.string(forKey: "loggedInUsername") else {
               DispatchQueue.main.async {
                   self.orders = []
               }
               return
           }

           let request: NSFetchRequest<Order> = Order.fetchRequest()
           request.predicate = NSPredicate(format: "user.username == %@", username)

           do {
               orders = try managedObjectContext.fetch(request)
           } catch {
               print("Error fetching orders: \(error)")
           }
    }

    func loadTickets() {
        if let username = sessionManager.currentUser?.username {
            let ticketRequest: NSFetchRequest<Ticket> = Ticket.fetchRequest()
            ticketRequest.predicate = NSPredicate(format: "user.username == %@", username)
            
            do {
                tickets = try managedObjectContext.fetch(ticketRequest)
            } catch {
                print("Error fetching orders: \(error)")
            }
        }
    }

    func addOrder(with details: [OrderDetails], user: User, showTime: ShowTime) {
        let newOrder = Order(context: managedObjectContext)
        newOrder.orderID = UUID()
        newOrder.orderTime = Date()
        newOrder.status = "New"
        newOrder.user = user
        newOrder.showtime = showTime
        
        for detail in details {
            newOrder.addToOrderdetails(detail)
            detail.order = newOrder
        }
        saveContext()
    }

    func addTicket(showTime: ShowTime, user: User, quantity: Int) {
        for _ in 0..<quantity {
            let newTicket = Ticket(context: managedObjectContext)
            newTicket.ticketID = UUID()
            newTicket.datePurchased = Date()
            newTicket.price = 30 // Assume a ticketPrice field in Movie
            newTicket.showtime = showTime
            newTicket.user = user
            tickets.append(newTicket)
        }
        saveContext()
    }

    func deleteOrder(_ order: Order) {
        managedObjectContext.delete(order)
        saveContext()
    }

    func deleteTicket(_ ticket: Ticket) {
        managedObjectContext.delete(ticket)
        saveContext()
    }

    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

