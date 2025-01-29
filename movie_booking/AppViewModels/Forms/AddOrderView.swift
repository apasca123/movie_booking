//
//  AddOrderView.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//

import SwiftUI
import CoreData

struct AddOrderView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var ordersViewModel: OrdersViewModel

    @State private var selectedFoodItems = Set<UUID>() // Store IDs of selected food items
    @State private var selectedShowTime: ShowTime?
    
    @FetchRequest(
        entity: FoodItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodItem.name, ascending: true)]
    ) var foodItems: FetchedResults<FoodItem>
    
    @FetchRequest(
        entity: ShowTime.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ShowTime.startTime, ascending: true)]
    ) var showTimes: FetchedResults<ShowTime>

    var body: some View {
        NavigationView {
            Form {
                foodSelectionSection
                showTimeSelectionSection
                placeOrderButton
            }
            .navigationBarTitle("Add New Order")
        }
    }

    // MARK: - Food Selection Section
    private var foodSelectionSection: some View {
        Section(header: Text("Select Food Items")) {
            List(foodItems, id: \.self) { item in
                Toggle(isOn: foodItemBinding(for: item)) {
                    Text(item.name ?? "Unknown Item")
                }
            }
        }
    }

    // MARK: - ShowTime Selection Section
    private var showTimeSelectionSection: some View {
        Section(header: Text("Select Show Time")) {
            Picker("Show Time", selection: $selectedShowTime) {
                ForEach(showTimes, id: \.self) { showTime in
                    if let movieTitle = showTime.movie?.title {
                        Text("\(movieTitle) at \(showTime.startTime ?? Date(), formatter: itemFormatter)")
                               .tag(showTime as ShowTime?)
                       } else {
                           Text("Unknown Movie at \(showTime.startTime ?? Date(), formatter: itemFormatter)")
                               .tag(showTime as ShowTime?)
                       }
                }
            }
        }
    }

    // MARK: - Place Order Button
    private var placeOrderButton: some View {
        Section {
            Button("Place Order") {
                placeOrder()
            }
            .disabled(selectedFoodItems.isEmpty || selectedShowTime == nil)
        }
    }

    // MARK: - FoodItem Selection Binding
    private func foodItemBinding(for item: FoodItem) -> Binding<Bool> {
        return Binding(
            get: { self.selectedFoodItems.contains(item.fooditemID ?? UUID()) },
            set: { isSelected in
                if isSelected {
                    self.selectedFoodItems.insert(item.fooditemID ?? UUID())
                } else {
                    self.selectedFoodItems.remove(item.fooditemID ?? UUID())
                }
            }
        )
    }

    // MARK: - Place Order Logic
    private func placeOrder() {
        guard let user = sessionManager.currentUser else {
            print("No logged-in user")
            return
        }

        guard let showTime = selectedShowTime else {
            print("No ShowTime selected")
            return
        }

        let newOrder = Order(context: context)
        newOrder.orderID = UUID()
        newOrder.orderTime = Date()
        newOrder.status = "New"
        newOrder.showtime = showTime
        newOrder.user = user

        for foodItemID in selectedFoodItems {
            if let foodItem = getFoodItem(by: foodItemID) {
                let detail = OrderDetails(context: context)
                detail.fooditem = foodItem
                detail.order = newOrder
                detail.quantity = 1
                detail.price = foodItem.price
            }
        }
        
        ordersViewModel.orders.append(newOrder)

        saveContext()
        resetSelection()
    }

    // MARK: - Helper Functions
    private func getFoodItem(by id: UUID) -> FoodItem? {
        let request: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        request.predicate = NSPredicate(format: "fooditemID == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch food item: \(error)")
            return nil
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save order: \(error)")
        }
    }

    private func resetSelection() {
        selectedFoodItems.removeAll()
        selectedShowTime = nil
    }

    // MARK: - Date Formatter
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
