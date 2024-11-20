//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 20/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "facebook")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.placeholder = "Email Address"
        
        return field
    }()
    
    private let password : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        
        return field
    }()
    
    private let logInButton : UIButton = {
       let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20,weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        password.delegate = self
        
        title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(logInButton)
        
        logInButton.addTarget(self,
                              action: #selector(logInButtonTaped),
                              for: .touchUpInside)

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.frame
        
        let size = scrollView.width / 3
        debugPrint(size)
        imageView.frame = CGRect(x: (scrollView.width-size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: Int(imageView.bottom)+10,
                                  width: Int(scrollView.width) - 60,
                                  height: 52)
        
        password.frame = CGRect(x: 30,
                                  y: Int(emailField.bottom)+20,
                                  width: Int(scrollView.width) - 60,
                                  height: 52)
        
        
        logInButton.frame = CGRect(x: 30,
                                  y: Int(password.bottom)+20,
                                  width: Int(scrollView.width) - 60,
                                  height: 52)
        
        
    }
    
    
    @objc private func logInButtonTaped() {
        
        emailField.resignFirstResponder()
        password.resignFirstResponder()
        
        guard let email = emailField.text, let password = password.text
                ,!email.isEmpty, !password.isEmpty, password.count >= 6 else {
                    alertUserLoginError()
                    return
                }
    }
    
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))

        present(alert, animated: true)
    }
    
    @objc private func didTapRegister(){
        
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            password.becomeFirstResponder()
        }
        
        if textField == password {
            logInButtonTaped()
        }
        
        return true
    }
    
    
}
