//
//  AddFriendViewController.swift
//  PhotosCoreData
//
//  Created by Brock Gibson on 3/18/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cellPhoneTextField: UITextField!
    
    var exisitingFriend: Friend?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.text = exisitingFriend?.firstName
        lastNameTextField.text = exisitingFriend?.lastName
        cellPhoneTextField.text = exisitingFriend?.contactInfo
        friendPhoto.image = exisitingFriend?.image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddFriendViewController.imageTapped(gestureRecognizer:)))
        friendPhoto.addGestureRecognizer(tapGesture)
        friendPhoto.isUserInteractionEnabled = true
        
        //circle image setup
        friendPhoto.layer.borderWidth = 1.0
        friendPhoto.layer.masksToBounds = false
        friendPhoto.layer.borderColor = UIColor.white.cgColor
        friendPhoto.layer.cornerRadius = self.friendPhoto.frame.width / 2
        friendPhoto.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    //Action
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let gallaryAction = UIAlertAction(title: "Open Gallary", style: .default) {
            UIAlertAction in self.openPhotoLibrary()
        }
        let cameraAction = UIAlertAction(title: "Open Camera", style: .default) {
            UIAlertAction in self.openCamera()
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorCheck() -> Bool {
        let firstName = firstNameTextField.text ?? "".trimmingCharacters(in: .whitespaces)
        let lastName = lastNameTextField.text ?? "".trimmingCharacters(in: .whitespaces)
        let contactInfo = cellPhoneTextField.text ?? "".trimmingCharacters(in: .whitespaces)

        if (firstName == "" || lastName == "" || contactInfo == "" || friendPhoto.image == nil) {
            alertNotifyUser(message: "Friend not saved! All fields must be filled out.")
            return false
        } else {
            return true
        }
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if errorCheck() == false {
            return
        }
        
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let contactInfo = cellPhoneTextField.text
        let profilePic = friendPhoto.image
        
        let friend: Friend?
        
        if let exisitingFriend = exisitingFriend {
            exisitingFriend.firstName = firstName
            exisitingFriend.lastName = lastName
            exisitingFriend.contactInfo = contactInfo
            exisitingFriend.image = profilePic
            
            friend = exisitingFriend
        } else {
            friend = Friend(firstName: firstName, lastName: lastName, contactInfo: contactInfo, image: profilePic)
        }
        
        if let friend = friend {
            do {
                let managedContext = friend.managedObjectContext
                
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Saving friend profile failed")
            }
        }
        
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(title: "Camera", message: "Camera Not Available On Device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let alert = UIAlertController(title: "Photo Library", message: "Photo Library Not Available On Device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        friendPhoto.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
    }

}
