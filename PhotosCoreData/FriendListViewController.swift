//
//  ViewController.swift
//  PhotosCoreData
//
//  Created by Brock Gibson on 3/18/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit
import CoreData

class FriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var FriendTableView: UITableView!
    var friends: [Friend] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
        
        do {
            friends = try managedContext.fetch(fetchRequest)
            FriendTableView.reloadData()
        }
        catch {
            print("Fetch of categories failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddFriendViewController,
            let row = FriendTableView.indexPathForSelectedRow?.row {
            destination.exisitingFriend = friends[row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddFriend", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        let friend = friends[indexPath.row]
        
        if let cell = cell as? FriendTableViewCell {
            cell.friendNameLabel.text = "\(friend.firstName ?? "") \(friend.lastName ?? "")"
            cell.friendContactInfoLabel.text = friend.contactInfo
            cell.friendImage.image = friend.image
            
            
            //circle image setup
            cell.friendImage.layer.borderWidth = 1.0
            cell.friendImage.layer.masksToBounds = false
            cell.friendImage.layer.borderColor = UIColor.white.cgColor
            cell.friendImage.layer.cornerRadius = cell.friendImage.frame.width / 2
            cell.friendImage.clipsToBounds = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFriend(at: indexPath)
        }
    }
    
    func deleteFriend(at indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        if let managedObjectContext = friend.managedObjectContext {
            managedObjectContext.delete(friend)
            do {
                try managedObjectContext.save()
                self.friends.remove(at: indexPath.row)
                FriendTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                FriendTableView.reloadData()
                print("friend could not be deleted")
            }
        }
    }
    
}
