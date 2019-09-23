//
//  App.swift
//
//  Created by Wayne Rumble on 20/09/2019.
//

import CouchDB
import Foundation
import Kitura
import LoggerAPI

public class App {
    
    var client: CouchDBClient?
    var database: Database?
    
    let router = Router()
    
    private func postInit() {
        let connectionProperties = ConnectionProperties(host: "db",
                                                        port: 5984,
                                                        secured: false,
                                                        username: "Test",
                                                        password: "test")
        
        client = CouchDBClient(connectionProperties: connectionProperties)

        client!.retrieveDB("users") { database, error in
            guard let database = database else {
                Log.info("Could not retrieve user database: "
                    + "\(String(describing: error?.localizedDescription)) "
                    + "- attempting to create new one.")
                self.createUsersDatabase()
                return
            }
            
            Log.info("Users database located - loading...")
            self.finalizeRoutes(with: database)
        }
    }
    
    private func createUsersDatabase() {
        client?.createDB("users") { database, error in
            guard let database = database else {
                Log.error("Could not create new database: "
                    + "(\(String(describing: error?.localizedDescription))) "
                    + "- user routes not created")
                return
            }
            self.finalizeRoutes(with: database)
        }
    }
    
    private func finalizeRoutes(with database: Database) {
        self.database = database
        initializeUserRoutes(app: self)
        Log.info("User routes created")
    }
    
    public func run() {
        let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8080") ?? 8080

        postInit()

        Kitura.addHTTPServer(onPort: port, with: router)
        Kitura.run()
    }
}

