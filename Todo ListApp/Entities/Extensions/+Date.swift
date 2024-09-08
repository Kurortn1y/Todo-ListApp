//
//  +Date.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import Foundation

extension Date {
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if Calendar.current.isDateInToday(self) {
            return "Today"
        } else {
            return formatter.string(from: self)
        }
    }
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM" //
        return formatter.string(from: self)
    }
}
