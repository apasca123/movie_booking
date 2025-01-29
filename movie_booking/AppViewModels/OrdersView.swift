import SwiftUI

struct OrdersView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var ordersViewModel: OrdersViewModel
    @State private var showingAddOrder = false

    var body: some View {
        NavigationView {
            VStack {
                if sessionManager.isUserLoggedIn {
                    ordersList
                } else {
                    Text("Please log in to see your orders.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationBarTitle("Orders")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $showingAddOrder, onDismiss: {
                ordersViewModel.loadOrders() // 🔹 Reîncarcă comenzile după plasarea unei comenzi
            }) {
                AddOrderView(ordersViewModel: ordersViewModel)
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .onAppear {
                if sessionManager.isUserLoggedIn {
                    ordersViewModel.loadOrders()
                }
            }
            .onChange(of: sessionManager.isUserLoggedIn) { newValue in
                if newValue {
                    ordersViewModel.loadOrders()  // 🔹 Reîncarcă comenzile după login
                } else {
                    ordersViewModel.orders.removeAll()  // 🔹 Șterge comenzile după logout
                }
            }
        }
    }

    private var ordersList: some View {
        List {
            ForEach(ordersViewModel.orders, id: \.self) { order in
                orderLink(order)
            }
            .onDelete(perform: deleteOrder)
        }
    }

    private func orderLink(_ order: Order) -> some View {
        NavigationLink(destination: OrderDetailView(ordersViewModel: ordersViewModel, order: order)) {
            VStack(alignment: .leading) {
                Text("Order #\(order.orderID?.uuidString ?? "Unknown")")
                Text("Placed on \(order.orderTime ?? Date(), formatter: itemFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Status: \(order.status ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(order.status == "Cancelled" ? .red : .primary)
            }
        }
    }

    private var addButton: some View {
        Button(action: {
            showingAddOrder = true
        }) {
            Image(systemName: "plus")
        }
    }

    private func deleteOrder(at offsets: IndexSet) {
        for index in offsets {
            let order = ordersViewModel.orders[index]
            ordersViewModel.deleteOrder(order)
        }
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
}
