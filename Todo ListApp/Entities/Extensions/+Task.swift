//
//  +Task.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import Foundation
import CoreData

extension Task {
    func toTaskEntity(in context: NSManagedObjectContext) -> TaskEntity {
        let taskEntity = TaskEntity(context: context)
        taskEntity.id = Int64(id)
        taskEntity.todo = todo
        taskEntity.taskDescription = description
        taskEntity.date = date
        taskEntity.completed = completed
        taskEntity.userId = Int64(userId ?? 0)
        return taskEntity
    }
}
