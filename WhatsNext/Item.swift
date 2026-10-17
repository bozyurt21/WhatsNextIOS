//
//  Item.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 17.10.2026.
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
