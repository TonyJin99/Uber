//
//  TJSignupViewController.swift
//  Uber
//
//  Created by Tony Jin on 6/14/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit
import CoreData


class TJSignupViewController: UIViewController {
    
    @IBOutlet weak var textF_Username: UITextField!
    @IBOutlet weak var taxtF_Password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func buttonActionCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func buttonActionDone(_ sender: AnyObject) {
 
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Information", in: managedContext)
       
        if self.textF_Username.text!.isEmpty || self.taxtF_Password.text!.isEmpty{
            let alertCont = UIAlertController(title: "Alert", message: "Please enter your username and password", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertCont.addAction(okButton)
            self.present(alertCont, animated: true, completion: nil)
        }
        else{
            let info = NSManagedObject(entity: entity!, insertInto: managedContext)
            info.setValue(self.textF_Username.text, forKey: "username")
            info.setValue(self.taxtF_Password.text, forKey: "password")
            
            do {
                try managedContext.save()
                self.dismiss(animated: true, completion: nil)
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }

        }
    }

}
