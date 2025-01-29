import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var usersViewModel: UsersViewModel
    @Binding var isAuthenticated: Bool
    @EnvironmentObject var sessionManager : SessionManager

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginFailed: Bool = false

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Login") {
                if usersViewModel.authenticateUser(username: username, password: password) {
                    isAuthenticated = true
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.set(username, forKey: "loggedInUsername")
                    sessionManager.loadCurrentUser();
                } else {
                    sessionManager.isUserLoggedIn = false;
                }
            }
            .alert(isPresented: $loginFailed) {
                Alert(title: Text("Login Failed"), message: Text("Incorrect username or password."))
            }
        }
    }
}
