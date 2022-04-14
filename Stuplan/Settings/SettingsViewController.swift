//
//  SettingsViewController.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-08.
//

import UIKit
import SQLite3
import UserNotifications
import Foundation
class SettingsViewController: UIViewController {
    var db : OpaquePointer?
    @IBOutlet weak var stateSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("switchIsOFF", forKey: "isEnable")
        
        let what = UserDefaults.standard.string(forKey:"isEnable")
        if(what == "switchIsOn"){
            pushNotification()
            print("push the notification")
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
    }
    @IBAction func enableNotification(_ sender: UISwitch) {
        var notificationEnable = ""
        if stateSwitch.isOn {
                print("The Switch is ON")
                stateSwitch.setOn(true, animated:true)
                notificationEnable = "switchIsOn"
                UserDefaults.standard.set(notificationEnable, forKey: "isEnable")
            pushNotification()
            } else {
                print("The Switch is OFF")
                notificationEnable = "switchIsOFF"
                UserDefaults.standard.set(notificationEnable, forKey: "isEnable")
                stateSwitch.setOn(false, animated:true)
            }
        let what = UserDefaults.standard.string(forKey:"isEnable")
        print("----\(String(describing: what))----")
    }
    @IBAction func clearAllData(_ sender: UIButton) {
        let alertController = UIAlertController(
               title: "Confirmation", message: "Are you sure wants to delete all data?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            self.deleteall()
        }))
        let defaultAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func deleteall() {
        
            let deleteTask = "DELETE FROM Task where taskId>0"
            let deleteCourses = "DELETE FROM Courses where courseId>0"
            var statement : OpaquePointer? = nil
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("mydata3.sqlite")

        let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
        //opening the database
        if sqlite3_open_v2(fileURL.path, &db,flags,nil) != SQLITE_OK {
            print("error opening database")
        }
            if sqlite3_prepare_v2(db, deleteTask, -1, &statement, nil) == SQLITE_OK{
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Task delete success")
                }else {
                    print("Task is not deleted in table")
                }
            }
        if sqlite3_prepare_v2(db, deleteCourses, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Courses delete success")
            }else {
                print("Courses is not deleted in table")
            }
        }
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func pushNotification(){
        
        
        
        //Authorization
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound])
        {(granted, error)in}
        
        //Notification Content
        let content = UNMutableNotificationContent()
        content.title = "STUPLAN"
        content.subtitle = "Hey, There !"
        content.body = "Check if you have any task left to do"
        content.sound = .default
        
        //Timing
        var dateComponent = DateComponents()
       dateComponent.hour = 11
       dateComponent.minute = 37
        
        
        //let date = Date().addingTimeInterval(15)
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        //let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        //Request
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: timeTrigger)
        
        // Register the request
        
        center.add(request) { (error) in
            //check the error parameter and handle any errors
        }
        
        
    }
    
}

struct Constants{
    var isEnable : String
    var dateTime: String
}
