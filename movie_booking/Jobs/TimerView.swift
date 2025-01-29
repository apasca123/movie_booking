import SwiftUI

struct TimerView: View {
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("Update in progress...")
            .onReceive(timer) { _ in
                // Acțiuni care trebuie executate periodic
                print("Timer fired")
            }
    }
}
