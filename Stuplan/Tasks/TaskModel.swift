//
//  TaskModel.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-11.
//

import Foundation

class TaskModel{
    var taskId: Int
    var taskName: String?
    var dueDate: String?
    var notes : String?
    var courseName :String?
    
    init(taskId: Int, taskName: String?, dueDate: String?, notes : String?,courseName :String){
        self.taskId = taskId
        self.taskName = taskName
        self.dueDate = dueDate
        self.notes = notes
        self.courseName = courseName
      }
    
    
    
}
