//
//  User.swift
//
//  Created by Wayne Rumble on 20/09/2019.
//

import CouchDB

struct User: Document {
    let _id: String?
    var _rev: String?
    
    var name: String
}
