//
//  CoursesViewController.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-08.
//

import UIKit
import SQLite3


class CoursesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    

    var courseList = [CourseModel]()
    var db: OpaquePointer?
    
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //the database file
        readValues()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
        readValues()
        courseTableView.reloadData()
    }
    
    
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        readValues()
        courseTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //this method is giving the row count of table view which is
        return courseList.count
        }


        //this method is binding the course name with the tableview cell
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseTableViewCell
            
            let course: CourseModel
            course = courseList[indexPath.row]
            
            //cell.courseId.text = String(course.courseId)
            cell.course.text = course.courseName
            
            cell.editButton.tag = courseList[indexPath.row].courseId
            cell.editButton.addTarget(self, action: #selector(editTapped(sender:)), for: .touchUpInside)
            
            return cell
        }
    
    @objc func editTapped(sender: UIButton) {
        performSegue(withIdentifier: "editCourse", sender: sender)
    }
    
    func readValues(){
        
        //first empty the list of courses
      courseList.removeAll()
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        
                //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        
        if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS Courses (courseId INTEGER PRIMARY KEY AUTOINCREMENT, courseName TEXT, flag BOOLEAN)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")

        }
          

          //this is our select query
          let queryString = "SELECT * FROM Courses"

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
                   let courseId = sqlite3_column_int(stmt, 0)
                   let courseName = String(cString: sqlite3_column_text(stmt, 1))

                   
                   print("\(courseId)\(courseName)")
                   //adding values to list
                   courseList.append(CourseModel(courseId: Int(courseId), courseName: String(describing: courseName)))
               }
        sqlite3_finalize(stmt)
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
//        self.courseTableView.reloadData()

      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let vc = segue.destination as? AddCourseViewController

        if let barButton = sender as? UIButton{
            if (barButton == addButton){
                vc?.operationType = "Add"
            }
            else if let button = sender as? UIButton{
                vc?.operationType = "Edit"
                vc?.courseId = String(button.tag)
            }
        }
    }
    
  
    
    
    /*
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         
         let idetifier = segue.identifier
         
         if(idetifier == "newGame"){
             return
         }
        
         
         
     }*/
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    var id = ""
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
   
        if editingStyle == .delete{
            
            tableView.beginUpdates()
            let course: CourseModel
            course = courseList[indexPath.row]
            id = String(course.courseId)
            
            let alertController = UIAlertController(
                   title: "Confirmation", message: "Are you sure you want to Remove ?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Remove", style: .cancel, handler: { (action: UIAlertAction!) in
                self.deleteCourses(id:self.id)
                self.courseList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }))
            
            let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(defaultAction)

            present(alertController, animated: true, completion: nil)
            
            tableView.endUpdates()
            
           
            
            
        }
       
        
    }
    
    func deleteCourses(id: String){
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        
        let deleteQuery = "DELETE FROM Courses where courseId = \(id);"

          var stmt: OpaquePointer?
          if sqlite3_prepare_v2(db, deleteQuery, -1, &stmt, nil) ==
              SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
              print("\nSuccessfully deleted row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          sqlite3_finalize(stmt)
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        // Create a new alert
        let dialogMessage = UIAlertController(title: "Attention", message: "Course name remvoed Succesfully !", preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        dialogMessage.addAction(defaultAction)

        present(dialogMessage, animated: true, completion: nil)
    }

}
