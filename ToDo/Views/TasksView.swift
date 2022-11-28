//
//  TasksView.swift
//  ToDo
//
//  Created by Alessio Poggi on 28/11/22.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var realmManager: RealmManager
    
    var body: some View {
        VStack {
            Text("My tasks")
                .font(.title2).bold()
                .padding(.horizontal)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if realmManager.tasks.count > 0 {
                List {
                    ForEach(realmManager.tasks, id: \.id) { task in
                        // Must wrap in an if statement because we don't want to display the task if it has been invalidated (will run into a crash otherwise)
                        if !task.isInvalidated && !task.isFrozen {
                            TaskRow(task: task.title, completed: task.completed)
                                .onTapGesture {
                                    realmManager.updateTask(id: task.id, completed: !task.completed)
                                }
                                /*.swipeActions {
                                    Button(role: .destructive) {
                                        realmManager.deleteTask(id: task.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }*/
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let taskTodelete = realmManager.tasks[index]
                            //realmManager.tasks.remove(at: index)
                            realmManager.deleteTask(id: taskTodelete.id)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
            }
            
            Spacer()
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
            .environmentObject(RealmManager())
    }
}
