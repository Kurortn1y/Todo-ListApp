//
//  NetworkManager.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

struct TaskListResponse: Codable {
    let todos: [Task]
    let total: Int
    let skip: Int
    let limit: Int
}

enum TaskListsErrors: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "No data received."
        case .decodingError:
            return "Failed to decode data."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
final class NetworkManager {
    func fetchTasks(completion: @escaping ([Task]?, TaskListsErrors?) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(nil, .invalidURL)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, .networkError(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, .noData)
                    }
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(TaskListResponse.self, from: data)
                    let tasks = response.todos
                    
                    DispatchQueue.main.async {
                        completion(tasks, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, .decodingError)
                    }
                }
            }
            
            task.resume()
        }
    }
}
