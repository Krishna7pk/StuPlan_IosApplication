//
//  CoursesModel.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-09.
//

import Foundation

class CourseModel{
    var courseId: Int
    var courseName: String?
    
    init(courseId: Int, courseName: String?){
          self.courseId = courseId
          self.courseName = courseName
      }
    
    
    
}
