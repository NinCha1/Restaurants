//
//  AuthenticationVM.swift
//  Restaurants
//
//  Created by Nina on 7/19/23.
//

import Foundation

class AuthenticationVM {
    var statusText = Dynamic("")
    
    func userButtonPressed(login: String, password: String) {
        if User.logins.contains(where: { $0.login == login && $0.password == password }) {
            statusText.value = "Success"
        } else {
            statusText.value = "Log in failed. Try again"
        }
    }
}
