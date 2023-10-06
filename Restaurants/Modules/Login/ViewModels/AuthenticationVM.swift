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
        NetworkingManager.shared.login(email: login, password: password) { [self] result in
            switch result {
            case .success(let token):
                print("Login successful. Token: \(token)")
                statusText.value = "Success"
            case .failure(let error):
                print("Login failed with error: \(error)")
                statusText.value = "Log In failed. Try again."
            }
        }
    }
}
