//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Emre Tekin on 15.11.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func singinClicked(_ sender: Any) {
        if mailText.text != "" && passwordText.text != ""{
            Auth.auth().signIn(withEmail: mailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)                }
            }
        }else{
            makeAlert(titleInput: "ERROR!", messageInput: "Username/Password?")        }
        
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if mailText.text != "" && passwordText.text != ""{
            
            Auth.auth().createUser(withEmail: mailText.text!,password: passwordText.text!) { (authData, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "ERROR!", messageInput: "Username/Password?")
            
        }
        
        
    }
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title:titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

