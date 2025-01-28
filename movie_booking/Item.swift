//
//  Item.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 28.01.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
