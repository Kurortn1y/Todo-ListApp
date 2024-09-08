//
//  Task.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import Foundation

struct Task: Identifiable, Equatable, Codable  {
    var id: Int
    var todo: String
    var description : String?
    var date: Date?
    var completed: Bool
    var userId: Int?
    
    init(
        id: Int,
        name: String,
        description: String,
        date: Date = Date(),
        isComplete: Bool = false,
        userId: Int? = nil
    ) {
        self.id = id
        self.todo = name
        self.description = description
        self.date = date
        self.completed = isComplete
        self.userId = userId
    }
}

