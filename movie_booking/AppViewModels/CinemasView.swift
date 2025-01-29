import SwiftUI

struct CinemasView: View {
    @ObservedObject var viewModel: CinemaViewModel
    @State private var showingAddCinema = false
    @State private var newCinemaName = ""
    @State private var newCinemaLocation = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.cinemas, id: \.self) { cinema in
                    VStack(alignment: .leading) {
                        Text(cinema.name ?? "").font(.headline)
                        Text(cinema.location ?? "").font(.subheadline)
                    }
                }
                .onDelete(perform: deleteCinema)
            }
            .navigationBarTitle("Cinemas")
            .navigationBarItems(trailing: Button(action: {
                showingAddCinema.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddCinema) {
                VStack {
                    TextField("Cinema Name", text: $newCinemaName)
                        .padding()
                    TextField("Location", text: $newCinemaLocation)
                        .padding()
                    Button("Add Cinema") {
                        viewModel.addCinema(location: newCinemaLocation, name: newCinemaName)
                        newCinemaName = ""
                        newCinemaLocation = ""
                        showingAddCinema = false
                    }
                    .padding()
                }
            }
        }
    }

    private func deleteCinema(at offsets: IndexSet) {
        for index in offsets {
            let cinema = viewModel.cinemas[index]
            viewModel.deleteCinema(cinema)
        }
    }
}
