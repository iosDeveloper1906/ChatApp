//
//  NewConversationViewController.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 20/11/24.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    private var userSearchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    
    private var userTableView: UITableView = {
        let tableView = UITableView()
        //tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var noUserLabel : UILabel = {
        let label = UILabel()
        label.text = "No user found"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.titleView = userSearchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        userTableView.delegate = self
        userTableView.dataSource = self

    }
    
    
    @objc func dismissSelf(){
        dismiss(animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userTableView.frame = view.bounds
    }


}

extension NewConversationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Vaibhav"
        return cell
    }
    
    
}
