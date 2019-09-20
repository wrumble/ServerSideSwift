//
//  UserPersistence.swift
//
//  Created by Wayne Rumble on 20/09/2019.
//

import Foundation
import CouchDB
import LoggerAPI

extension User {
    
    class Persistence {
        
        static func getAll(from database: Database, callback:
            @escaping (_ users: [User]?, _ error: Error?) -> Void) {
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    Log.error("Error retrieving all documents: \(String(describing: error))")
                    return callback(nil, error)
                }
                
                let users = documents.decodeDocuments(ofType: User.self)
                callback(users, nil)
            }
            
        }
        
        static func save(_ user: User, to database: Database, callback:
            @escaping (_ user: User?, _ error: Error?) -> Void) {
            database.create(user) { document, error in
                guard let document = document else {
                    Log.error("Error creating new document: \(String(describing: error))")
                    return callback(nil, error)
                }
                
                database.retrieve(document.id, callback: callback)
            }
            
        }
        
        static func delete(_ userID: String, from database: Database, callback:
            @escaping (_ error: Error?) -> Void) {
            database.retrieve(userID) { (user: User?, error: CouchDBError?) in
                guard let user = user, let userRev = user._rev else {
                    Log.error("Error retrieving document: \(String(describing:error))")
                    return callback(error)
                }
                
                database.delete(userID, rev: userRev, callback: callback)
            }
            
        }
    }
}
