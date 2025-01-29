import CoreData
import Foundation

class CinemaViewModel: ObservableObject {
    @Published var cinemas: [Cinema] = []
    private var managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        loadCinema()
    }

    func loadCinema() {
        let fetchRequest: NSFetchRequest<Cinema> = Cinema.fetchRequest()
        do {
            cinemas = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func addCinema(location: String, name: String) {
        let newCinema = Cinema(context: managedObjectContext)
        newCinema.name = name;
        newCinema.location = location;

        saveContext();
    }

    func updateCinema(_ cinema: Cinema, location: String?, name: String?) {
        if let location = location {
            cinema.location = location
        }
        if let name = name {
            cinema.name = name
        }
        saveContext()
    }

    func deleteCinema(_ cinema: Cinema) {
        managedObjectContext.delete(cinema)
        saveContext()
    }

    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            managedObjectContext.rollback()
            print("Failed to save context: \(error)")
        }
    }
}
