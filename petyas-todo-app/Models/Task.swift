//
//  Task.swift
//  petyas-todo-app
//
//  Created by Petya Kantarska on 29.11.24.
//

import FirebaseFirestore
import Foundation

struct Task: Identifiable, Codable {
    @DocumentID var id: String? // This is automatically assigned by Firestore
    var title: String
    var isCompleted: Bool
    var createdAt: Timestamp

    // Initializer to easily create a Task object
    init(title: String, isCompleted: Bool = false, createdAt: Timestamp = Timestamp()) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
