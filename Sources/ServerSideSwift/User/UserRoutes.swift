//
//  UserRoutes.swift
//
//  Created by Wayne Rumble on 20/09/2019.
//

import CouchDB
import Kitura
import KituraContracts
import LoggerAPI

private var database: Database?

func initializeUserRoutes(app: App) {
    
    database = app.database
    
    app.router.get("/users", handler: getUsers)
    app.router.post("/users", handler: addUser)
    app.router.delete("/users", handler: deleteUser)
}

private func getUsers(completion: @escaping ([User]?,
    RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    User.Persistence.getAll(from: database) { users, error in
        return completion(users, error as? RequestError)
    }
}

private func addUser(user: User, completion: @escaping (User?,
    RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    User.Persistence.save(user, to: database) { newUser, error in
        return completion(newUser, error as? RequestError)
    }
}

private func deleteUser(id: String, completion: @escaping
    (RequestError?) -> Void) {
    guard let database = database else {
        return completion(.internalServerError)
    }
    User.Persistence.delete(id, from: database) { error in
        return completion(error as? RequestError)
    }
}

