//
//  Todo_ListAppApp.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

@main
struct Todo_ListAppApp: App {
    var body: some Scene {
        WindowGroup {
            ToDoRouter.makeContent()
        }
    }
}
