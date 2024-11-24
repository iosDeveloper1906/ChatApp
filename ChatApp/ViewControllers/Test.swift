//
//  Test.swift
//  ChatApp
//
//  Created by Vaibhav Gawde on 23/11/24.
//

import UIKit

class Test: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TestTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        //tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        cell.label.text = "First"
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
//                return UITableViewCell(style: .default, reuseIdentifier: "cell")
//            }
//                        
//            cell.textLabel?.text = "data[indexPath.row]"
            
        
        return cell
    }

}
