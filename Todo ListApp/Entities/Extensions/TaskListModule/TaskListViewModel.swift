//
//  TaskListViewModel.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

protocol TasksListViewProtocol: AnyObject{
    func displayTasks(_ tasks: [Task])
}

final class TasksListViewModel: ObservableObject, TasksListViewProtocol {
    
    @Published var tasks: [Task] = []
    @Published var selectedSegment = 0
    @Published var showingAddTask = false
    @Published var editingTask: Task?
    
    @Published  var id: Int = 0
    @Published  var name: String = ""
    @Published  var description: String = ""
    @Published  var date: Date = Date()
    
    var presenter: TasksPresenter?
    
    init() {
        self.presenter = TasksPresenter(view: self)
        presenter?.fetchTasks()
    }
 
    func displayTasks(_ tasks: [Task]) {
        DispatchQueue.main.async {
            self.tasks = tasks
        }
    }
    
   func toggleTaskCompletion(task: Task) {
        withAnimation {
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index].completed.toggle()
            }
        }
    }
}
