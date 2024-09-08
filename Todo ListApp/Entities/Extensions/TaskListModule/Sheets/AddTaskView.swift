//
//  AddTaskView.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

#Preview {
    ToDoRouter.makeContent()
}

struct AddTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TasksListViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")
                    .bold()
                ) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }
                Button(action: {
                    let newTask = Task(id: viewModel.id, name: viewModel.name, description: viewModel.description, date: Date())
                    viewModel.presenter?.addTask(id: newTask.id, name: newTask.todo, description: newTask.description ?? "" , date: newTask.date  ?? Date.now )
                    dismiss()
                }) {
                    Text("Add Task")
                }
            }
            .navigationTitle("Add Task")
        }
    }
}

