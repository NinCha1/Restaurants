//
//  ViewController.swift
//  Restaurants
//
//  Created by Nina on 3/12/23.
//

import UIKit

final class LoginViewController: UIViewController {
    enum Constant {
        static let defaultInset: CGFloat = 20
        static let defaultHieght: CGFloat = 55
        static let textFieldConst: CGFloat = 20
        static let labelConst: CGFloat = 70
        static let belowLabel: CGFloat = 150
    }
    
    var viewModel = AuthenticationVM()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "My Restaurants"
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 35.0)
        return label
    }()
    
    private let statusLabel : UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name:"HelveticaNeue", size: 17.0)
        return label
    }()
    
    private let loginTextField: UITextField = {
        let textField = UITextFieldPadding()
        textField.textColor = .gray
        textField.placeholder = "Username"
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15.0
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextFieldPadding()
        textField.textColor = .gray
        textField.placeholder = "Password"
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15.0
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton = CustomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        setupUI()
        setupTextFields()
    }
    
    func bindViewModel() {
        viewModel.statusText.bind({ [weak self] (statusText) in
            DispatchQueue.main.async {
                if statusText == "Success" {
                    let restaurantViewController = RestaurantViewConrtoller()
                    self?.navigationController?.pushViewController(restaurantViewController, animated: false)
                } else {
                    self?.statusLabel.text = statusText
                }
            }
        })
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        loginButton.backgroundColor = .black
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 15.0
        loginButton.isEnabled = false
        
        
        [loginButton, loginLabel, statusLabel, loginTextField, passwordTextField].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constant.textFieldConst),
            loginButton.heightAnchor.constraint(equalToConstant: Constant.defaultHieght),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.defaultInset),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.defaultInset),
            
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.labelConst),
            
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.defaultInset),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.defaultInset),
            loginTextField.heightAnchor.constraint(equalToConstant: Constant.defaultHieght),
            loginTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: Constant.belowLabel),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.defaultInset),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.defaultInset),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constant.defaultHieght),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: Constant.textFieldConst),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
        ])
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        if let login = loginTextField.text, let password = passwordTextField.text {
            viewModel.userButtonPressed(login: login, password: password)
        }
    }
    
    @objc private func textFieldDidChange() {
        let isLoginFieldFilled = !(loginTextField.text?.isEmpty ?? true)
        let isPasswordFieldFilled = !(passwordTextField.text?.isEmpty ?? true)
        
        loginButton.isEnabled = isLoginFieldFilled && isPasswordFieldFilled
    }
    
    private func setupTextFields() {
        loginTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

