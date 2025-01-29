import SwiftUI

struct MoviesView: View {
    @ObservedObject var viewModel: MoviesViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.movies, id: \.self) { movie in
                    VStack(alignment: .leading) {
                        Text(movie.title ?? "").font(.headline)
                        Text(movie.movieDescription ?? "").font(.subheadline)
                    }
                }
                .onDelete(perform: deleteMovie)
            }
            .navigationBarTitle("Movies")
            .navigationBarItems(trailing: Button(action: {
                // Logică pentru adăugarea unui film nou
            }) {
                Image(systemName: "plus")
            })
        }
    }

    private func deleteMovie(at offsets: IndexSet) {
        for index in offsets {
            let movie = viewModel.movies[index]
            viewModel.deleteMovie(movie)
        }
    }
}
