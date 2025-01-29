//
//  EntryView.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//

import SwiftUI

struct EntryView: View {
    @ObservedObject var usersViewModel: UsersViewModel

    @State private var isShowingLogin = true
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        NavigationView {
            VStack {
                
                if UserDefaults.standard.bool(forKey: "isUserLoggedIn"){
                    DashboardView(isUserLoggedIn: $sessionManager.isUserLoggedIn)
                }
                else {
                    if isShowingLogin {
                        AuthenticationView(usersViewModel: usersViewModel, isAuthenticated: $sessionManager.isUserLoggedIn)
                    } else {
                        UserRegistrationView(usersViewModel: usersViewModel)
                    }
                    
                    Button(isShowingLogin ? "Need an account? Register" : "Already have an account? Login") {
                        isShowingLogin.toggle()
                    }
                    .padding()
                }
            }
            .navigationBarTitle(isShowingLogin ? "Login" : "Register", displayMode: .inline)
        }
    }
}
