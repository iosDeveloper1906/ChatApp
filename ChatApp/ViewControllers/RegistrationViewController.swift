//
//  RegistrationViewController.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 20/11/24.
//

import UIKit
import FirebaseAuth


class RegistrationViewController: UIViewController {
    
    private let scrollView : UIScrollView  = {
        let scrollview = UIScrollView()
        scrollview.clipsToBounds = true
        return scrollview
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
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
        field.returnKeyType = .continue
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
    
    private let firstName :  UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.placeholder = "First Name"
        
        return textField
    }()
    
    private let lastName :  UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.placeholder = "Last Name"
        
        return textField
    }()
    
    private let registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .link
        button.titleLabel?.font = .systemFont(ofSize: 20,weight: .bold)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        emailField.delegate = self
        password.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        
        registerButton.addTarget(self, action: #selector(validation), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(firstName)
        scrollView.addSubview(lastName)
        scrollView.addSubview(registerButton)
        
        scrollView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled  = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImage))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        scrollView.frame = view.frame
    
        let size = scrollView.width / 3
        debugPrint(size)
        imageView.frame = CGRect(x: (scrollView.width-size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        imageView.layer.cornerRadius = imageView.width/2.0
        
        emailField.frame = CGRect(x: 30,
                                  y: Int(imageView.bottom)+10,
                                  width: Int(scrollView.width) - 60,
                                  height: 52)
        
        password.frame = CGRect(x: 30,
                                  y: Int(emailField.bottom)+10,
                                  width: Int(scrollView.width) - 60,
                                  height: 52)
        
        firstName.frame = CGRect(x: 30,
                                  y: Int(password.bottom)+10,
                                  width: Int(scrollView.width) - 60,
                                  height: 52)
        
        lastName.frame = CGRect(x: 30,
                                  y: Int(firstName.bottom)+20,
                                  width: Int(scrollView.width) - 60,
                                  height: 52)
        
        
        registerButton.frame = CGRect(x: 30,
                                  y: Int(lastName.bottom)+20,
                                  width: Int(scrollView.width) - 60,
                                  height: 52)
    }
    
    
   @objc private func validation() {
        guard let emailValue = emailField.text,let password = password.text,
              let firstNameValue = firstName.text, let lastNameValue = lastName.text,
              password.count >= 6 else {
            
               errorAlert()
               return
            
        }
       
       DataBaseManager.shared.validateEmail(with: emailValue) { [weak self]exists in
           
           guard let strongSelf = self else{
               return
           }
           
           guard !exists else {
               strongSelf.errorAlert(message: "Looks like a user account for that email addesss already exisits.")
               return
           }
           
           FirebaseAuth.Auth.auth().createUser(withEmail: emailValue, password: password) { [weak self] result, error in
               
               guard let strongSelf = self else {
                   return
               }
               
               guard let authResult = result, error == nil else {
                   debugPrint("Error occured while creating user")
                   return
               }
               
               
               let user = authResult.user
               
               
               DataBaseManager.shared.insertUser(with: User(firstName: firstNameValue, lastName: lastNameValue, emailID: emailValue))
               
               let storyBoard = UIStoryboard(name: "Main", bundle: nil)
               let vc = storyBoard.instantiateViewController(withIdentifier: "Dashboard")
               strongSelf.navigationController?.pushViewController(vc, animated: true)
               strongSelf.navigationController?.dismiss(animated: true, completion: nil)
               
           }
       }
       
    
       
    }
    
    @objc private func profileImage(){
        presentPhotoActiohSheet()
    }
    
    
    private func errorAlert(message: String = "Please enter all the information to register"){
        
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}

extension RegistrationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            password.becomeFirstResponder()
        }
        
        if textField == password {
            firstName.becomeFirstResponder()
        }
        
        if textField == firstName {
            lastName.becomeFirstResponder()
        }
        
        if textField == lastName {
            validation()
        }
        
        return true
        
    }
    
}


extension RegistrationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    func presentPhotoActiohSheet(){
        
        let alert = UIAlertController(title: "Profile Picture",
                                      message: "How would you like to select a picture",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            
            self?.presentCamera()
            
        }))
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            
            self?.presentGallery()
        }))
        
        present(alert, animated: true)
    }
    
    
    func presentCamera() {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func presentGallery(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.imageView.image = selectedImage
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)

    }
    
}
