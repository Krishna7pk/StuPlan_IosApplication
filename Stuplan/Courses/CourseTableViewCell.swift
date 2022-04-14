//
//  CourseTableViewCell.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-09.
//

import UIKit
import SQLite3
class CourseTableViewCell: UITableViewCell {
    var courseList = [CourseModel]()
    var db: OpaquePointer?
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var editButton: UIButton!
    //    @IBOutlet weak var courseId: UILabel!
//    @IBOutlet weak var editButton: UIButton!
//    @IBOutlet weak var saveButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
//    @IBAction func enableCourseName(_ sender: UIButton) {
//        course.isEnabled = true
//        saveButton.isHidden = false
//        editButton.isHidden = true
//        course.borderStyle = .line
//        print("--2 -- \(String(describing: course.text))")
//    }
    
//    @IBAction func updateCourseName(_ sender: UIButton) {
//        course.isEnabled = false
//        saveButton.isHidden = true
//        editButton.isHidden = false
//        course.borderStyle = .none
//        print("--3 -- \(String(describing: course.text))")
//        saveCourseName()
//
//    }
    
    func saveCourseName(){
        print("--4 -- \(String(describing: course.text))")
        /*
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        let updateStatementString = "UPDATE Courses SET courseName = \(String(describing: course.text)) WHERE courseId = \(String(describing: courseId.text));"

          var updateStatement: OpaquePointer?
          if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          sqlite3_finalize(updateStatement)
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
       */
       
    }
    
    @IBAction func updateName(_ sender: UITextField) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

        
  
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//    }
}
