//
//  CustomButton.swift
//  Restaurants
//
//  Created by Nina on 9/26/23.
//

import UIKit

class CustomButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = .black
            } else {
                backgroundColor = .gray
            }
        }
    }
}
