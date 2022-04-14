//
//  AddTaskViewController.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-11.
//

import UIKit
import SQLite3


class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    var db: OpaquePointer?
   
    @IBOutlet weak var taskError: UILabel!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var courseError: UILabel!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var dateError: UILabel!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var notesError: UILabel!
    @IBOutlet weak var notes: UITextField!
    var courseList: [String] = [String]()
    var thePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePicker.delegate = self
        thePicker.dataSource = self
        courseField.inputView = thePicker
        // Do any additional setup after loading the view.
        readValues()
        submitForm()
        
    }
    
    /* -------------- Form Validation------------------*/
    func validateForm()
        {
           
            taskError.isHidden = false
            courseError.isHidden = false
            dateError.isHidden = false
            notesError.isHidden = false
            
            taskError.text = "Required"
            courseError.text = "Required"
            dateError.text = "Required"
            notesError.text = "Required"
        }
    
    
    func  submitForm()
        {
           
            taskError.isHidden = true
            courseError.isHidden = true
            dateError.isHidden = true
            notesError.isHidden = true
            
            taskError.text = "Required"
            courseError.text = "Required"
            dateError.text = "Required"
            notesError.text = "Required"
        }
    
    /* -------------- End of Form Validation------------------*/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        return courseList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return courseList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
            courseField.text = courseList[row]
      
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
        
        if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS Courses (courseId INTEGER PRIMARY KEY AUTOINCREMENT, courseName TEXT)", nil, nil, nil) != SQLITE_OK {
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
                   //let courseId = sqlite3_column_int(stmt, 0)
                   let courseName = String(cString: sqlite3_column_text(stmt, 1))
                   //adding values to list
                   courseList.append(String(describing: courseName))
               }
        sqlite3_finalize(stmt)
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
//        self.courseTableView.reloadData()

      }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func AddTask(_ sender: Any) {
        let task = taskName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let notes1 = notes.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let courseName1 = courseField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        print("CourseName: \(String(describing: courseName1))")
        
        if((task != "") && (notes1 != "") && courseName1 != ""){
    
        
        
        print("clicked and get course name\(String(describing: courseField))")
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("mydata3.sqlite")

        let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
        //opening the database
        if sqlite3_open_v2(fileURL.path, &db,flags,nil) != SQLITE_OK {
            print("error opening database")
        }

        //creating table
        if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS Task (taskId INTEGER PRIMARY KEY AUTOINCREMENT, taskName TEXT, dueDate TEXT, notes TEXT, courseName TEXT, flag TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")

        }


        var stmt : OpaquePointer?

        let insertQuery = "INSERT INTO Task (taskName, dueDate, notes, courseName,flag)  VALUES(?,?,?,?,?)"

        if(sqlite3_prepare_v2(db,insertQuery, -1, &stmt,nil)) != SQLITE_OK{
            print("Error binding Query")
            return
        }

        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        //binding the parameters
        
        
        print("received Task Name: \(String(describing: task))")
        
        if sqlite3_bind_text(stmt, 1, task, -1, SQLITE_TRANSIENT) != SQLITE_OK{ //(courseName! as NString).intValue
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding task Name: \(errmsg)")
            return
        }
        // format date
        // Setup date (yyyy-MM-dd HH:mm:ss)
     
        dueDate.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM / dd"
        let selectedDate = dateFormatter.string(from: dueDate.date)
        
        print("selectedDate : \(String(describing: selectedDate))")
        
        if sqlite3_bind_text(stmt, 2, selectedDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{ //(courseName! as NString).intValue
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding dateString : \(errmsg)")
            return
        }
        print("received notes Name: \(String(describing: notes1))")
        if sqlite3_bind_text(stmt, 3, notes1, -1, SQLITE_TRANSIENT) != SQLITE_OK{ //(courseName! as NString).intValue
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding notes : \(errmsg)")
            return
        }
        

        if sqlite3_bind_text(stmt, 4, courseName1, -1, SQLITE_TRANSIENT) != SQLITE_OK{ //(courseName! as NString).intValue
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding notes : \(errmsg)")
            return
        }
        
        
        if sqlite3_bind_text(stmt, 5, "1", -1, SQLITE_TRANSIENT) != SQLITE_OK{ //(courseName! as NString).intValue
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding flags : \(errmsg)")
            return
        }


        if (sqlite3_step(stmt) != SQLITE_DONE){
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting : \(errmsg)")
        }
        else{
            print("Task name is inserted")
        }
        sqlite3_finalize(stmt)

        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
           
            // Create a new alert
            let dialogMessage = UIAlertController(title: "Attention", message: "Task is Added Succesfully !", preferredStyle: .alert)

            present(dialogMessage, animated: true, completion: nil)
            taskName.text = ""
            courseField.text = ""
            notes.text = ""
            performSegue(withIdentifier: "taskSegue", sender: self)
        
        }
        else{
            validateForm()
            
        }
    }
    
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        performSegue(withIdentifier: "taskSegue", sender: self)
    }
    
}


