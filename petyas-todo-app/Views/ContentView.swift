//
//  ContentView.swift
//  petyas-todo-app
//
//  Created by Petya Kantarska on 29.11.24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var firestoreViewModel = FirestoreViewModel()
    @State private var newTaskTitle = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: addTask) {
                        Text("Add")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }

                List {
                    ForEach(firestoreViewModel.tasks) { task in
                        HStack {
                            Text(task.title)
                            Spacer()
                            if task.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .onTapGesture {
                            firestoreViewModel.toggleTaskCompletion(task: task)
                        }
                    }
                    .onDelete { indexSet in
                        let task = firestoreViewModel.tasks[indexSet.first!]
                        if let taskId = task.id {
                            firestoreViewModel.deleteTask(taskId: taskId)
                        }
                    }
                }
                .navigationBarTitle("To-Do List")
                .onAppear {
                    firestoreViewModel.fetchTasks()
                }
            }
        }
    }
    
    func addTask() {
        if !newTaskTitle.isEmpty {
            firestoreViewModel.addTask(title: newTaskTitle)
            newTaskTitle = "" // Reset the text field
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

