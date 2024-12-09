//
//  NewConversationViewController.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 20/11/24.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    
    private let spinner = JGProgressHUD(style: .dark)
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    
    private var userSearchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    
    private var userTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var noUserLabel : UILabel = {
        let label = UILabel()
        label.text = "No user found"
        label.textColor = .gray
        label.isHidden = true
    
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(userTableView)
        view.addSubview(noUserLabel)
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.titleView = userSearchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userSearchBar.delegate = self
      
    

    }
    
    
    @objc func dismissSelf(){
        dismiss(animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userTableView.frame = view.bounds
        noUserLabel.frame = CGRect(x: view.width/4,
                                   y: (view.height-200)/2,
                                   width: view.width/2,
                                   height: 200)
    }


}

extension NewConversationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    
}

extension NewConversationViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text, !searchText.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        self.results.removeAll()
        spinner.show(in: view)
        self.searchUser(with: searchText)
        
    }
    
    
    func searchUser(with searchKey: String){
        debugPrint("searchUser \(searchKey)")

        if hasFetched {
            filterUser(with: searchKey)
        }else{
            DataBaseManager.shared.fetchUsers { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                    
                case .success(let userCollection):
                    strongSelf.hasFetched = true
                    strongSelf.users = userCollection
                    strongSelf.filterUser(with: searchKey)
                case .failure(let error):
                    debugPrint("Failed")
                }
            }
        }
        
    }
    
    func filterUser(with trem: String) {
        debugPrint("filterUser \(trem)")
        guard hasFetched else {
            return
        }
        
        self.spinner.dismiss()
        
        let filterResult : [[String: String]] = self.users.filter({
            
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            debugPrint("filterUser \(name)")
            return name.hasPrefix(trem.lowercased())
            
        })
        
        self.results = filterResult
        updateUI()
        
        
    }
    
    func updateUI (){
        debugPrint("updateUI")

        if results.isEmpty {
            self.noUserLabel.isHidden = false
            self.userTableView.isHidden = true
        }else{
            self.noUserLabel.isHidden = true
            self.userTableView.isHidden = false
            self.userTableView.reloadData()
         }
    }
}
