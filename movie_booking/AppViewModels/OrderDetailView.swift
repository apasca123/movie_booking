import SwiftUI

struct OrderDetailView: View {
    @ObservedObject var ordersViewModel: OrdersViewModel
    var order: Order

    var body: some View {
        List {
            Section(header: Text("Showtime Details")) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(order.showtime?.movie?.title ?? "Unknown Movie")
                        .font(.headline)
                    Text("Cinema: \(order.showtime?.hall?.cinema?.name ?? "Unknown Cinema")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Showtime: \(order.showtime?.startTime ?? Date(), formatter: itemFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 5)
            }

            Section(header: Text("Ordered Food Items")) {
                if order.orderDetailsArray.isEmpty {
                    Text("No food items ordered")
                        .foregroundColor(.gray)
                } else {
                    ForEach(order.orderDetailsArray, id: \.self) { detail in
                        HStack {
                            Text(detail.fooditem?.name ?? "Unknown Item")
                            Spacer()
                            Text("$\(detail.price, specifier: "%.2f")")
                        }
                    }
                }
            }

            Section(header: Text("Order Summary")) {
                HStack {
                    Text("Order Status:")
                    Spacer()
                    Text(order.status ?? "Unknown")
                        .foregroundColor(order.status == "Cancelled" ? .red : .primary)
                        .fontWeight(.bold)
                }

                HStack {
                    Text("Total Amount:")
                    Spacer()
                    Text("$\(calculateTotal(), specifier: "%.2f")")
                        .fontWeight(.bold)
                }
            }
        }
        .navigationBarTitle("Order #\(order.orderID?.uuidString ?? "Unknown")", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if order.status != "Cancelled" {
                    Button("Cancel Order") {
                        cancelOrder()
                    }
                }
            }
        }
    }

    private func calculateTotal() -> Double {
        order.orderDetailsArray.reduce(0) { $0 + $1.price }
    }

    private func cancelOrder() {
        ordersViewModel.orders.removeAll(where: { $0.orderID == order.orderID })
        ordersViewModel.deleteOrder(order)
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}
