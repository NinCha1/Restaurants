//
//  User.swift
//  Restaurants
//
//  Created by Nina on 7/17/23.
//

import Foundation


struct User {
    let login: String?
    let password: String?
}

extension User {
    static var logins = [
        User(login: "lexons", password: "12345"),
    ]
}
