//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Emre Tekin on 15.11.2021.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do{
        try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
        print("Error")
    }
    


}
}
