//
//  FirestoreViewModel.swift
//  petyas-todo-app
//
//  Created by Petya Kantarska on 29.11.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestore

class FirestoreViewModel: ObservableObject {
    @Published var tasks = [Task]() // List of tasks to be observed by SwiftUI views
    private var db = Firestore.firestore() // Firestore reference

    // Fetch tasks from Firestore
    func fetchTasks() {
        db.collection("tasks").order(by: "createdAt") // Fetch tasks, ordered by creation date
            .addSnapshotListener { snapshot, error in // Real-time updates
                if let error = error {
                    print("Error getting tasks: \(error)")
                    return
                }
                
                guard let snapshot = snapshot else { return }
                // Convert Firestore documents into Task objects and update the tasks array
                self.tasks = snapshot.documents.compactMap { doc in
                    try? doc.data(as: Task.self)
                }
            }
    }

    // Add a new task
    func addTask(title: String) {
        let newTask = Task(title: title) // Create a new task object
        do {
            _ = try db.collection("tasks").addDocument(from: newTask) // Add to Firestore
        } catch {
            print("Error adding task: \(error)")
        }
    }

    // Delete a task
    func deleteTask(taskId: String) {
        db.collection("tasks").document(taskId).delete { error in
            if let error = error {
                print("Error deleting task: \(error)")
            }
        }
    }

    // Toggle task completion status
    func toggleTaskCompletion(task: Task) {
        guard let taskId = task.id else { return } // Ensure the task has an ID
        db.collection("tasks").document(taskId).updateData([
            "isCompleted": !task.isCompleted // Flip the completion status
        ]) { error in
            if let error = error {
                print("Error updating task: \(error)")
            }
        }
    }
}
