//
//  TJAccountViewController.swift
//  Uber
//
//  Created by Tony Jin on 6/15/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit

class TJAccountViewController: UIViewController {

    @IBOutlet weak var sidebarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            
            sidebarItem.target = self.revealViewController()
            sidebarItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }

}
