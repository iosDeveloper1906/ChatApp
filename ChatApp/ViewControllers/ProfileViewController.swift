//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 20/11/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    let data = ["Log Out"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        self.navigationItem.hidesBackButton = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = createTableHeader()
        
    
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .black
        
    
            
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       logOutAlert()
       
    }
    
    private func createTableHeader() -> UIView{
        
        guard let email = UserDefaults.standard.value(forKey: Constants.UserEmail) as? String else {
            return UIView()
        }
        
        let safeEmail = DataBaseManager.safeEmail(with: email)
        let fileName = "\(safeEmail)_profile_pic"
        let path = "image/"+fileName
    
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.view.width,
                                              height: 300))
        
        headerView.backgroundColor = .link
        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150)/2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = .white
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.width/2
        imageView.layer.masksToBounds = true
        headerView.addSubview(imageView)
        debugPrint("FileName \(path)")
        StorageManager.shared.downloadURL(with: path) {[weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            switch result {
                
            case .success( let url):
                debugPrint(url)
                strongSelf.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
                debugPrint("Error \(error)")
            }
        }
        
        
        return headerView
    }
    
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let imageData = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                imageView.image = image
            }
           
        }.resume()
    }
    
    
    private func logOutAlert(){
        let logOutAlert = UIAlertController(title: "Log Out", message: "Are you sure, you want to logout ?", preferredStyle: .alert)
        
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {[weak self] _ in
            
            guard let strongSelf = self else {
                return
            }
            do {
                try FirebaseAuth.Auth.auth().signOut()
            }catch{
                
            }
           


            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let loginVC = storyboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController else {
                    return
                }
                
                // Embed in navigation controller
                let navigationController = UINavigationController(rootViewController: loginVC)
                
                // Set it as the root view controller
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                sceneDelegate?.window?.rootViewController = navigationController
                sceneDelegate?.window?.makeKeyAndVisible()
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(logOutAlert, animated: true)
    }
    

}
