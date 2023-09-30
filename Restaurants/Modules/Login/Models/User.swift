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
        User(login: "Test", password: "12345"),
        User(login: "gelik", password: "gelik"),
        User(login: "12", password: "34")
    ]
}
