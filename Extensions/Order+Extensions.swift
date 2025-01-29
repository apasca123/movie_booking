//
//  Order+Extensions.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//

import Foundation
import CoreData

extension Order {
    var orderDetailsArray: [OrderDetails] {
        let set = orderdetails as? Set<OrderDetails> ?? []
        return set.sorted {
            $0.fooditem?.name ?? "" < $1.fooditem?.name ?? ""
        }
    }
}
