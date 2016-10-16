//
//  TJLoginViewController.swift
//  Uber
//
//  Created by Tony Jin on 6/14/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit

class TJLoginViewController: UIViewController {
    
    @IBOutlet weak var textF_Username: UITextField!
    @IBOutlet weak var textF_Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textF_Username.resignFirstResponder()
        textF_Password.resignFirstResponder()
    }

    @IBAction func itemActionCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func itemActionDone(_ sender: AnyObject) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<Information>(entityName: "Information")
        
        let Username = self.textF_Username.text
        let Password = self.textF_Password.text
        
        let pre = NSPredicate(format: "username = %@ AND password = %@", Username!, Password!)
        fetchRequest.predicate = pre
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                self.performSegue(withIdentifier: "hello", sender: self)
            }
            else{
                let alertCont = UIAlertController(title: "Alert", message: "wrong username or password", preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alertCont.addAction(okButton)
                self.present(alertCont, animated: true, completion: nil)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    
    }
    


}
