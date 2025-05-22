//
//  Item.swift
//  ios-example
//
//  Created by Root Pay Inc. on 22/05/25.
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
