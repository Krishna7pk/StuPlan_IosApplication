//
//  DBHandler.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-04-09.
//

import Foundation
import SQLite3

class DBHandler {
    
    private var connection: OpaquePointer?
    private var statement: OpaquePointer?
    
    func open() -> Bool {
        // Create connection to database
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("expenseTracker2.sqlite")
            
        sqlite3_open(fileUrl.path, &connection)
            
        if sqlite3_open(fileUrl.path, &connection) != SQLITE_OK{
            print("Error Opening Database")
            return false
        }
        print("Connection opened succefully")
        return true
    }
    
    func createTable() -> Bool{

        let createTaleQuerry = "CREATE TABLE IF NOT EXISTS Transactions ( id    INTEGER, type    TEXT, value    REAL, category    TEXT, description    TEXT, date    TEXT, PRIMARY KEY(id AUTOINCREMENT))"
        
        if sqlite3_exec(connection, createTaleQuerry, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return false
        }
        
        print("Table created")
        return true
    }
    
    func cleanTable(){
        let cleanQuerry = "DROP table Transactions"
        
        if sqlite3_prepare(connection, cleanQuerry, -1,&statement, nil) != SQLITE_OK{
            print("Error creating querry " + cleanQuerry)
        }
        sqlite3_step(statement)
        sqlite3_reset(statement)
        
    }
    
    func getTotal(type:String)->Double{
     
        let getTotalQuerry = "SELECT sum(value) from Transactions where type =?"
        
        if sqlite3_prepare(connection, getTotalQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return 0.0
        }
    
        if sqlite3_bind_text(statement, 1, type ,-1, nil) != SQLITE_OK{
            print("Error Binding " + type)
            sqlite3_reset(statement)
            return 0.0
        }
     
        if sqlite3_step(statement) == SQLITE_ROW {
            let value = sqlite3_column_double(statement, 0)
            sqlite3_reset(statement)
            print(value)
            return value
        }
        sqlite3_reset(statement)
        return 0.0
    }
    
    /*
    func getAll(type:String)-> [Transaction]{
     
        let getTotalQuerry = "SELECT * from Transactions where type =?"
        
        if sqlite3_prepare(connection, getTotalQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return []
        }
    
        if sqlite3_bind_text(statement, 1, type ,-1, nil) != SQLITE_OK{
            print("Error Binding " + type)
            sqlite3_reset(statement)
            return []
        }
     
        if sqlite3_step(statement) == SQLITE_ROW {
            let value = sqlite3_column_double(statement, 0)
            sqlite3_reset(statement)
            print(value)
            return value
        }
        sqlite3_reset(statement)
        return 0.0
    }*/
    
    func getLatest(type:String)->Double{
     
        let getTotalQuerry = "SELECT value from Transactions where type = ? order by id DESC LIMIT 1"
        
        if sqlite3_prepare(connection, getTotalQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return 0.0
        }
    
        if sqlite3_bind_text(statement, 1, type ,-1, nil) != SQLITE_OK{
            print("Error Binding " + type)
            sqlite3_reset(statement)
            return 0.0
        }
     
        if sqlite3_step(statement) == SQLITE_ROW {
            let value = sqlite3_column_double(statement, 0)
            sqlite3_reset(statement)
            print(value)
            return value
        }
        sqlite3_reset(statement)
        return 0.0
    }
    
    func insertTransaction(transaction:Transaction) -> Bool{
        
        print("Inserting " + transaction.toString())
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let insertQuerry = "INSERT INTO Transactions (type, value, category, description, date) VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare(connection, insertQuerry,-1,&statement, nil) != SQLITE_OK{
            print("Error creating querry")
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 1, transaction.type ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.type)
            sqlite3_reset(statement)
            return false
        }
     
        if sqlite3_bind_double(statement, 2, transaction.value) != SQLITE_OK{
            print("Error Binding " + String(transaction.value))
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 3, transaction.catagory ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.catagory)
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 4, transaction.description ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.description)
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_bind_text(statement, 5, transaction.date ,-1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error Binding " + transaction.date)
            sqlite3_reset(statement)
            return false
        }
        
        if sqlite3_step(statement) != SQLITE_DONE{
            print("Saving failed " + String(cString: sqlite3_errmsg(connection)))
            sqlite3_reset(statement)
            return false
        }
        
        sqlite3_reset(statement)
        print("Saved succefully ")
        return true
    }

    
}
