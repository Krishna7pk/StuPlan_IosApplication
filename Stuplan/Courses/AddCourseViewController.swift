//
//  AddCourseViewController.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-09.
//

import UIKit
import SQLite3

class AddCourseViewController: UIViewController {
    
    var db: OpaquePointer?
    var operationType:String = ""
    var courseId:String = ""

    
    @IBOutlet weak var courseError: UILabel!
    @IBOutlet weak var addCourseLabel: UITextField!
    @IBOutlet weak var viewTitle: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseError.isHidden = true
        
        viewTitle.text = operationType + " Course"
        
        if (operationType == "Edit"){
            if (courseId != "nil"){
                addButton.setTitle(operationType, for:.normal)
                populateCourseData(id:courseId)
            }
            else{
                print("Invalid transaction")
                performSegue(withIdentifier: "tableView", sender: self)
            }
        }
        
    }
    
   
func populateCourseData(id:String){
        
        
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        
                //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }

          //this is our select query
          let queryString = "SELECT * FROM Courses where courseID =\(id)"

          //statement pointer
          var stmt:OpaquePointer? = nil
            //preparing the query
               if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("error preparing insertview: \(errmsg)")
                   return
               }

               //traversing through all the records
               while(sqlite3_step(stmt) == SQLITE_ROW){
                   let courseName = String(cString: sqlite3_column_text(stmt, 1))
                   addCourseLabel.text = courseName
                   //adding values to list
                   }
        sqlite3_finalize(stmt)
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    
        
//        self.courseTableView.reloadData()

      }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "viewCourses", sender: self)
    }
    
    @IBAction func addCourseButton(_ sender: Any) {
        let courseName = addCourseLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(courseName != ""){
        
            if (operationType == "Edit"){
                upDateCourseData(id:courseId, course_name:courseName!)
            }
            else{
                addcourseDate(course_name:courseName!)
            }
        }
    else{
        courseError.isHidden = false
        courseError.text = "Required"
        }
}
    
    func addcourseDate(course_name:String){
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("mydata3.sqlite")
        let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
        //opening the database
        if sqlite3_open_v2(fileURL.path, &db,flags,nil) != SQLITE_OK {
            print("error opening database")
        }
        //creating table
        if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS Courses (courseId INTEGER PRIMARY KEY AUTOINCREMENT, courseName TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")

        }
                var stmt : OpaquePointer?
                let insertQuery = "INSERT INTO Courses(courseName) VALUES(?)"
                if(sqlite3_prepare_v2(db,insertQuery, -1, &stmt,nil)) != SQLITE_OK{
                    print("Error binding Query")
                    return
                }
                let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
                //binding the parameters
                if sqlite3_bind_text(stmt, 1, course_name, -1, SQLITE_TRANSIENT) != SQLITE_OK{ //(courseName! as NString).intValue
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding course Name: \(errmsg)")
                    return
                }
                if (sqlite3_step(stmt) != SQLITE_DONE){
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting course Name: \(errmsg)")
                }
                else{
                    print("Course name is inserted")
                }
                sqlite3_finalize(stmt)
                
                if sqlite3_close(db) != SQLITE_OK {
                    print("error closing database")
                }
                        
                        // Create a new alert
                        let dialogMessage = UIAlertController(title: "Attention", message: "Course name added Successfully!", preferredStyle: .alert)

                        // Present alert to user
                        self.present(dialogMessage, animated: true, completion: nil)
                        
                addCourseLabel.text = ""
                performSegue(withIdentifier: "viewCourses", sender: self)
                
                        
                    
    }

    func upDateCourseData(id: String, course_name:String){
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
      
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let updateQuerry = "Update Courses set courseName = ? where courseId = ?"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare(db, updateQuerry,-1,&updateStatement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(updateStatement)
            return
        }
        
      
        
        if sqlite3_bind_text(updateStatement, 1, course_name ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + course_name)
            sqlite3_reset(updateStatement)
            return
        }
        
        if sqlite3_bind_int(updateStatement, 2, Int32(id)!) != SQLITE_OK{
            print("Error Binding " + String(id))
            sqlite3_reset(updateStatement)
            return
        }
        
        if sqlite3_step(updateStatement) != SQLITE_DONE{
            print("Editing failed " + String(cString: sqlite3_errmsg(db)))
            sqlite3_reset(updateStatement)
            return
        }
        
        sqlite3_reset(updateStatement)
        
        
          sqlite3_finalize(updateStatement)
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        // Create a new alert
        let dialogMessage = UIAlertController(title: "Attention", message: "Course name is update successfully!", preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        dialogMessage.addAction(defaultAction)

        // Present alert to user
        self.present(dialogMessage, animated: true, completion: nil)
        
        addCourseLabel.text = ""
        performSegue(withIdentifier: "viewCourses", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
