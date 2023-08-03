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
        if login != User.logins[0].login || password != User.logins[0].password {
            statusText.value = "Log in failed"
        } else {
            statusText.value = "You sucessfully logged in."
        }
    }
}
