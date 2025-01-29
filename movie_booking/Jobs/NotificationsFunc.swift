import UserNotifications

func scheduleMovieStartNotification(for movie: Movie) {
    let content = UNMutableNotificationContent()
    content.title = "Filmul începe curând!"
    content.body = "Filmul \(movie.title ?? "") începe în 15 minute."
    content.sound = UNNotificationSound.default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (15*60), repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error)")
        }
    }
}
