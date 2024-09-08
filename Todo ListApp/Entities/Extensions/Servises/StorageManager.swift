//
//  StorageManager.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo List") // Подставьте ваше имя модели
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Fetching tasks from Core Data
    func fetchTasks() -> [TaskEntity] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            print("Загружено задач из Core Data: \(tasks)")
            return tasks
        } catch {
            print("Ошибка при загрузке задач из Core Data: \(error)")
            return []
        }
    }
    
    // Adding a new task to Core Data
    func addTask(id: Int, name: String, description: String, date: Date, completed: Bool) {
        let newTask = TaskEntity(context: context)
        newTask.id = Int64(id)
        newTask.todo = name
        newTask.taskDescription = description
        newTask.date = date
        newTask.completed = completed
        saveContext()
        print("Задача добавлена в Core Data: \(newTask)")
    }
    
    // Updating an existing task in Core Data
    func updateTask(id: Int, name: String, description: String, date: Date) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let result = try context.fetch(fetchRequest)
            if let taskEntity = result.first {
                taskEntity.todo = name
                taskEntity.taskDescription = description
                taskEntity.date = date
                saveContext()
            }
        } catch {
            print("Ошибка при обновлении задачи в Core Data: \(error)")
        }
    }
    
    // Deleting a task from Core Data
    func deleteTask(id: Int) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let result = try context.fetch(fetchRequest)
            if let taskEntity = result.first {
                context.delete(taskEntity)
                saveContext()
            }
        } catch {
            print("Ошибка при удалении задачи из Core Data: \(error)")
        }
    }
}
    

