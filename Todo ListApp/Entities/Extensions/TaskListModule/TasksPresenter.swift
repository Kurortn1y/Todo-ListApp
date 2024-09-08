//
//  TasksPresenter.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

protocol TasksPresenterProtocol: AnyObject {
    func didFetchTasks(_ tasks: [Task])
    func didAddTask()
    func didDeleteTask()
    func didEditTask()
}


final class TasksPresenter: TasksPresenterProtocol {
    
    weak var view: TasksListViewProtocol?
    var interactor: TasksInteractorProtocol?
    
    init(view: TasksListViewProtocol? ) {
        self.view = view
    }
    
    func fetchTasks() {
        interactor?.fetchTask()
    }
    
    func addTask(id: Int, name: String, description: String, date: Date) {
        interactor?.addNewTask(id: id, name: name, description: description, date: date)
    }
    
    func deleteTask(taskID: Int) {
        interactor?.deleteTask(id: taskID)
    }
    
    func editTask(id: Int, name: String, description: String, date: Date) {
        interactor?.editTask(id: id, name: name, description: description, date: date)
    }
    
    // MARK: Protocol methods
    func didFetchTasks(_ tasks: [Task]) {
        view?.displayTasks(tasks)
    }
    
    func didAddTask() {
        interactor?.fetchTask()
    }
    
    func didEditTask() {
        interactor?.fetchTask()
    }
    
    func didDeleteTask() {
        interactor?.fetchTask()
    }
}
