//
//  TasksInteractor.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

protocol TasksInteractorProtocol: AnyObject {
    func fetchTask()
    func addNewTask(id: Int, name: String, description: String, date: Date)
    func deleteTask(id: Int)
    func editTask(id: Int, name: String, description: String, date: Date)
}

final class TasksInteractor: TasksInteractorProtocol {
    
    private let networkManager = NetworkManager()
    private var tasks: [Task] = []
    weak var presenter: TasksPresenterProtocol?
    
    // MARK: Protocol methods
    func fetchTask() {

        let taskEntities = StorageManager.shared.fetchTasks()
        tasks = taskEntities.map { $0.toModel() }
        
        if tasks.isEmpty {

            networkManager.fetchTasks { [weak self] tasks, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Ошибка при загрузке задач: \(error.localizedDescription)")
                    } else if let tasks = tasks {
                        print("Задачи успешно загружены из сети:")
                        for task in tasks {
                            print("ID: \(task.id), Задача: \(task.todo), Завершена: \(task.completed), UserID: \(String(describing: task.userId))")
                        }
                        self?.tasks = tasks

                        tasks.forEach { task in
                            StorageManager.shared.addTask(
                                id: task.id,
                                name: task.todo,
                                description: task.description ?? "",
                                date: task.date ?? Date(),
                                completed: task.completed
                            )
                        }
                        self?.presenter?.didFetchTasks(tasks)
                    } else {
                        print("Неизвестная ошибка: нет данных и нет ошибки.")
                    }
                }
            }
        } else {

            presenter?.didFetchTasks(tasks)
        }
    }
    
    func addNewTask(id: Int, name: String, description: String, date: Date) {
        StorageManager.shared.addTask(
            id: id,
            name: name,
            description: description,
            date: date,
            completed: false
        )
        presenter?.didAddTask()
    }
    
    func editTask(id: Int, name: String, description: String, date: Date) {
        StorageManager.shared.updateTask(
            id: id,
            name: name,
            description: description,
            date: date
        )
        presenter?.didEditTask()
    }
    
    func deleteTask(id: Int) {
        StorageManager.shared.deleteTask(id: id)
        presenter?.didDeleteTask()
    }
}
