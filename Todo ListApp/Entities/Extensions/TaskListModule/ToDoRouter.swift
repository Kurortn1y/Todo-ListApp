//
//  ToDoRouter.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

protocol ToDoRouterProtocol {
    associatedtype ContentView: View
    static func makeContent() -> ContentView
}

final class ToDoRouter: ToDoRouterProtocol {
    
    static func makeContent() -> some View {
        let viewModel = TasksListViewModel()
        let view = TasksListView(viewModel: viewModel)
        let interactor = TasksInteractor()
        let presenter = TasksPresenter(view: viewModel)
        
        viewModel.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}

