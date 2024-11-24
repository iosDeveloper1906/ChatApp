//
//  SplashViewController.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 23/11/24.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()

        moveToNext()

    }
    
    
    func moveToNext(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if FirebaseAuth.Auth.auth().currentUser == nil {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "Login")
                self.navigationController?.pushViewController(vc, animated: true)
            } else{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "Dashboard")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        
        
        }
    }
    

    

}
