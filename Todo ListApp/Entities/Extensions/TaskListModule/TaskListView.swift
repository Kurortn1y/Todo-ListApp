//
//  TaskListView.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

#Preview {
    ToDoRouter.makeContent()
}

//MARK: - TaskListView

struct TasksListView: View {
    
    @StateObject var viewModel = TasksListViewModel()
    
    
    var body: some View {
        framing()
    }
    
    func framing() -> some View {
        UpperSectionCons.mainViewColor
            .ignoresSafeArea()
            .overlay(content())
    }
    
    func content() -> some View {
        VStack {
            VStack(alignment: .leading) {
                upperSection()
                middleSection()
            }
            ScrollView {
                VStack {
                    ForEach(filteredTasks(), id: \.id) { task in
                        taskSection(for: task)
                            .transition(.opacity)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddTask) {
                AddTaskView(viewModel: viewModel)
            }
            .sheet(item: $viewModel.editingTask) { task in
                            EditTaskView(task: Binding(
                                get: { task },
                                set: { updatedTask in
                                    if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                        viewModel.tasks[index] = updatedTask
                                    }
                                }
                            ))
                            .environmentObject(viewModel)
            }
            .onAppear(perform: {
                viewModel.presenter?.fetchTasks()
            })
        }
    }
    
//MARK: - Sections
    
    private func upperSection() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Today's Task")
                    .font(.system(size: UpperSectionCons.todaysTaskTextSize))
                    .bold()
                Text(Date().formattedDay)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: {
                viewModel.showingAddTask.toggle()
            }, label: {
                Text(UpperSectionCons.addButtonText)
                    .font(.subheadline)
                    .bold()
            })
            .frame(width: UpperSectionCons.addButtonWidth, height: UpperSectionCons.addButtonHeght)
            .background(UpperSectionCons.addButtonColor)
            .cornerRadius(UpperSectionCons.addButtonCornerRadius)
        }
        .padding(.horizontal, UpperSectionCons.upperSectionHoritontalPadding)
    }
    
    private func middleSection() -> some View {
        
    customSegmentedControlWithTasks(selectedSegment: $viewModel.selectedSegment, tasks: viewModel.tasks)
        .padding()
    }
    
    
    func taskSection(for task: Task) -> some View {
        ZStack {
            Color.white
            VStack {
                HStack {
                    VStack(alignment: .leading){
                        Text(task.todo)
                            .strikethrough(task.completed)
                            .bold()
                        Text(task.description ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Toggle(isOn: Binding<Bool>(
                                        get: { !task.completed },
                                        set: { newValue in
                                            withAnimation {
                                                viewModel.toggleTaskCompletion(task: task)
                                            }
                                        }
                    )) {
                    }.toggleStyle(CheckboxToggleStyle())
                }
                Divider()
                HStack(alignment: .firstTextBaseline) {
                    Text(task.date?.formattedDate() ?? Date.now.formattedDate())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(task.date?.formattedTime() ?? Date.now.formattedTime())
                        .font(.subheadline)
                        .foregroundStyle(TaskSectionCons.taskSectionTimerColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, TaskSectionCons.taskSectionHorizontalPadding)
            .animation(.easeInOut, value: task.completed)
        }
        .frame(width: TaskSectionCons.taskSectionFrameWidth , height: TaskSectionCons.taskSectionFrameHeight)
        .clipShape(RoundedRectangle(cornerRadius: TaskSectionCons.taskSectionCornerRadius))
        .onTapGesture {
            viewModel.editingTask = task
            }
        .swipeActions {
            Button(role: .destructive) {
                    if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                        viewModel.presenter?.deleteTask(taskID: index)
                    }
            } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
}

//MARK: - Extension TaskListView Custom SegmentedControl and filtration methods

extension TasksListView {
    func customSegmentedControlWithTasks(selectedSegment: Binding<Int>, tasks: [Task]) -> some View {
        HStack {
            segmentButton(index: 0, title: "All", count: tasks.count, selectedSegment: selectedSegment)
            Divider()
                .frame(width: SegmentSectionCons.segmentDividerWidth, height: SegmentSectionCons.segmentDividerHeight)
            segmentButton(index: 1, title: "Open", count: tasks.filter { !$0.completed }.count, selectedSegment: selectedSegment)
            segmentButton(index: 2, title: "Closed", count: tasks.filter { $0.completed }.count, selectedSegment: selectedSegment)
        }
        .padding()
    }

    private func segmentButton(index: Int, title: String, count: Int, selectedSegment: Binding<Int>) -> some View {
        Button(action: {
            selectedSegment.wrappedValue = index
        }) {
            HStack {
                Text(title)
                    .bold()
                    .foregroundColor(selectedSegment.wrappedValue == index ? Color.blue : Color.gray.opacity(SegmentSectionCons.grayColorOpacityValue))
                ZStack {
                    Text("\(count)")
                        .frame(width: SegmentSectionCons.countREctangleWidth, height: SegmentSectionCons.countREctangleHeight)
                        .background(selectedSegment.wrappedValue == index ? Color.blue : Color.gray.opacity(SegmentSectionCons.grayColorOpacityValue))
                        .clipShape(RoundedRectangle(cornerRadius: SegmentSectionCons.countShapeCornerRadius))
                        .foregroundColor(.white)
                        .font(.system(size: SegmentSectionCons.countFontSize))
                        .bold()
                }
            }
        }
        .padding(.horizontal, SegmentSectionCons.segmentPaddingValue)
        .buttonStyle(PlainButtonStyle())
        
        
    }
    
    private func filteredTasks() -> [Task] {
        switch viewModel.selectedSegment {
        case 1:
            return viewModel.tasks.filter { !$0.completed }
        case 2:
            return viewModel.tasks.filter { $0.completed }
        default:
            return viewModel.tasks
        }
    }
}

//MARK: - Extension TasksListView Constants

extension TasksListView {
    enum UpperSectionCons {
        
        static let mainViewColor = Color.secondary.opacity(0.18)
        static let addButtonText = "+ New Task"
        static let addButtonWidth: CGFloat = 125
        static let addButtonHeght: CGFloat = 38
        static let addButtonColor = Color.blue.opacity(0.10)
        static let addButtonCornerRadius:CGFloat = 10
        static let todaysTaskTextSize: CGFloat = 24
        static let upperSectionHoritontalPadding: CGFloat = 25
    }
    
    enum TaskSectionCons {
        static let taskSectionTimerColor = Color.secondary.opacity(0.4)
        static let taskSectionHorizontalPadding: CGFloat  = 20
        static let taskSectionFrameWidth: CGFloat = 350
        static let taskSectionFrameHeight: CGFloat = 120
        static let taskSectionCornerRadius: CGFloat = 24
    }
    
    enum SegmentSectionCons{
        static let segmentDividerWidth: CGFloat = 1
        static let segmentDividerHeight: CGFloat = 16
        static let countREctangleWidth: CGFloat = 30
        static let countREctangleHeight: CGFloat = 20
        static let countShapeCornerRadius: CGFloat = 12
        static let countFontSize: CGFloat = 10
        static let grayColorOpacityValue: Double = 0.2
        static let segmentPaddingValue: CGFloat = 10
    }
}
