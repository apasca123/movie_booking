//
//  RegistrationView.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//

import SwiftUI

struct UserRegistrationView: View {
    @ObservedObject var usersViewModel: UsersViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""

    var body: some View {
        Form {
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            TextField("Email", text: $email)
            Button("Register") {
                usersViewModel.addUser(username: username, password: password, email: email)
            }
        }
    }
}
