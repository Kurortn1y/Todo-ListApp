//
//  EditTaskView.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//


import SwiftUI

#Preview {
    ToDoRouter.makeContent()
}


struct EditTaskView: View {
    @Binding var task: Task
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: TasksListViewModel
    
    @State private var name: String
    @State private var description: String
    @State private var date: Date
    
    init(task: Binding<Task>) {
        _task = task
        _name = State(initialValue: task.wrappedValue.todo)
        _description = State(initialValue: task.wrappedValue.description ?? "")
        _date = State(initialValue: task.wrappedValue.date ?? Date.now)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                Button("Save") {
                    let updatedTask = Task(
                        id: task.id,
                        name: name,
                        description: description,
                        date: date,
                        isComplete: task.completed,
                        userId: task.userId
                    )
                    
                    viewModel.presenter?.editTask(id: updatedTask.id, name: updatedTask.todo, description: updatedTask.description ?? "", date: updatedTask.date ?? Date.now)
                    
                    dismiss()
                }
                .disabled(name.isEmpty)
                
                Button("Delete") {
                    viewModel.presenter?.deleteTask(taskID: task.id)
                    
                    dismiss()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Edit Task")
        }
    }
}
