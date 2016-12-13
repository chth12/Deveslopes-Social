//
//  FeedVC.swift
//  Deveslopes Social
//
//  Created by Christopher Heins on 12/6/16.
//  Copyright © 2016 Christopher Todd Heins. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("TODD: \(posts.count)")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
            return cell
                }
        } else {
            //print("TODD: could not configure cell")
            return PostCell()
        }
}
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
            
        } else {
            print("TODD: Did not pick a valid photo")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func signOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        //performSegue(withIdentifier: "goToSignIn", sender: nil)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("TODD: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("TODD: An image must be selected")
            return
        }
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUID = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUID).put(imageData, metadata: metaData) {(metadata, error) in
                if error != nil {
                    print("TODD: Unable to upload image to Firebase storage")
                } else {
                    print("TODD: Successfully loaded image to Firebsae storage")
                    let downloadURL = metaData.downloadURL()?.absoluteString
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        postLabel.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
