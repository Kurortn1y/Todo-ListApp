//
//  TaskEntity.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import Foundation
import CoreData

extension TaskEntity {
    func toModel() -> Task {
        let taskId = Int(self.id)
        let taskName = self.todo ?? "Untitled Task"
        let taskDescription = self.taskDescription ?? ""
        let taskDate = self.date ?? Date()
        let taskCompleted = self.completed
        let taskUserId = self.userId != 0 ? Int(self.userId) : nil

        return Task(
            id: taskId,
            name: taskName,
            description: taskDescription,
            date: taskDate,
            isComplete: taskCompleted,
            userId: taskUserId
        )
    }
}

