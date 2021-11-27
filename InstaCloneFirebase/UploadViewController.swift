//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Emre Tekin on 15.11.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var uploadButton: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media").child("images")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpeg")
            imageRef.putData(data, metadata: nil) { metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    imageRef.downloadURL { url, error in
                        if error == nil{
                            let imageURL = url?.absoluteString
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreRef: DocumentReference? = nil
                            
                            
                            let firestorePosts = ["imageUrl":imageURL!, "postedBy": Auth.auth().currentUser!.email!, "postComment": self.textView.text,"dates": FieldValue.serverTimestamp(), "likes": 0 ] as [String : Any]
                            
                            firestoreRef = firestoreDatabase.collection("Posts").addDocument(data:firestorePosts, completion: { error in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                }else{
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.textView.text = ""
                                    
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                        
                    }
                }
            }
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message:messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
