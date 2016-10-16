//
//  TJSidebarTableViewController.swift
//  Uber
//
//  Created by Tony Jin on 6/14/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit

class TJSidebarTableViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    var menuItems: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tableview.separatorStyle = false
        
        menuItems = ["YIXIN", "RIDER", "DRIVER", "HISTORY", "HELP", "FREE RIDES", "PROMOTIONS", "NOTIFICATIONS", "SETTING", "LOG OUT"]

        self.tableView.backgroundColor = UIColor.black
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).row == 0 {
            let cellID = "YIXIN"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TJAccountCell
            cell.imageview.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
            cell.imageview.image = UIImage(named: "yixin")
            cell.imageview.layer.cornerRadius = 25
            cell.imageview.layer.masksToBounds = true;
            cell.imageview.layer.borderWidth = 2
            cell.imageview.layer.borderColor = UIColor.white.cgColor

            cell.textLabel?.textColor = UIColor.white
   
            cell.labelName.text = "YiXin Tang"
            return cell
           
        }
        else{
            let CellIdentifier = self.menuItems[(indexPath as NSIndexPath).row]
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
            
            cell.textLabel?.text = self.menuItems[(indexPath as NSIndexPath).row]
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 0 {
            return 60
        }
        return 44
    }
}
