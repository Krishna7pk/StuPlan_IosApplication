//
//  CompletedViewController.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-08.
//

import UIKit
import SQLite3
class CompletedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var taskList = [TaskModel]()
    var db: OpaquePointer?
    @IBOutlet weak var completeTaskTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        featchTaskData()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
        featchTaskData()
        completeTaskTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRow row: Int, inComponent component: Int) {
       
            print(taskList[row])
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //this method is giving the row count of table view which is
        return taskList.count
        }
 
    

        //this method is binding the course name with the tableview cell
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "completedTask", for: indexPath) as! CompletedTaskViewCell
            
            let taskOb: TaskModel
            taskOb = taskList[indexPath.row]
            cell.nameOfTask.text = taskOb.taskName
            cell.nameOfCours.text = taskOb.courseName
            cell.date.text = taskOb.dueDate
            cell.notes.text = taskOb.notes
            return cell
        }
    
    
    //Read data from the database
    func featchTaskData(){
        
        taskList.removeAll()
        
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        
        if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS Task (taskId INTEGER PRIMARY KEY AUTOINCREMENT, taskName TEXT, dueDate TEXT, notes TEXT, courseName TEXT, flag TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")

        }
        
        //this is our select query
        let queryString = "SELECT * FROM Task where flag=0"
        
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
                 let taskId = sqlite3_column_int(stmt, 0)
                 let taskName = String(cString: sqlite3_column_text(stmt, 1))
                 let dueDate = String(cString: sqlite3_column_text(stmt, 2))
                 let notes = String(cString: sqlite3_column_text(stmt, 3))
                 let courseName = String(cString: sqlite3_column_text(stmt, 4))

                 //adding values to list
                 taskList.append(TaskModel(taskId: Int(taskId), taskName: String(describing: taskName),dueDate: String(describing: dueDate),notes: String(describing: notes),courseName: String(describing: courseName)))
             }
        sqlite3_finalize(stmt)
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    var id = ""
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
   
        if editingStyle == .delete{
            
            tableView.beginUpdates()
            let taskOb: TaskModel
            taskOb = taskList[indexPath.row]
            id = String(taskOb.taskId)
            let alertController = UIAlertController(
                   title: "Confirmation", message: "Are you sure you want to Remove?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Remove", style: .cancel, handler: { (action: UIAlertAction!) in
                self.deleteTask(id:self.id)
                self.taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(defaultAction)

            present(alertController, animated: true, completion: nil)
            
            tableView.endUpdates()
            
        }
       
        
    }
    
    func deleteTask(id: String){
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        
        let deleteQuery = "DELETE FROM Task where taskID = \(id);"

          var updateStatement: OpaquePointer?
          if sqlite3_prepare_v2(db, deleteQuery, -1, &updateStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully deleted row.")
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
        // Create a new alert
        let dialogMessage = UIAlertController(title: "Attention", message: "Succesfully Removed!", preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        dialogMessage.addAction(defaultAction)

        present(dialogMessage, animated: true, completion: nil)

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
