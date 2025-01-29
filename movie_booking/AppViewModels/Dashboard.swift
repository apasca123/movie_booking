//
//  Dashboard.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//

import SwiftUI

struct DashboardView: View {
    @Binding var isUserLoggedIn: Bool
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        Button("Logout") {
            UsersViewModel(context: PersistenceController.shared.container.viewContext).logoutUser();
            sessionManager.logoutUser()
        }
        TabView {
            OrdersView(ordersViewModel: OrdersViewModel(context: PersistenceController.shared.container.viewContext, sessionManager: sessionManager))
                .tabItem {
                    Label("Comenzi", systemImage: "cart")
                }
            MoviesView(viewModel: MoviesViewModel(context: PersistenceController.shared.container.viewContext))
                .tabItem {
                    Label("Filme", systemImage: "film")
                }
            
            CinemasView(viewModel: CinemaViewModel(context: PersistenceController.shared.container.viewContext))
                .tabItem {
                    Label("Cinematografe", systemImage: "building.2.crop.circle")
                }
                .accentColor(.red); // Setează culoarea accentului pentru tab-uri, potrivit cerințelor tale de UI
        
        }
        .navigationBarTitle("Dashboard")
    }
}
