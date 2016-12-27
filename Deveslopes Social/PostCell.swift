//
//  PostCell.swift
//  Deveslopes Social
//
//  Created by Christopher Heins on 12/6/16.
//  Copyright © 2016 Christopher Todd Heins. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var likesImage: UIImageView!

    var post: Post!
    var likesref: FIRDatabaseReference!
    var profile: UITapGestureRecognizer!
    var controller = UIViewController()
    var storyBoard = UIStoryboard()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
        profile = UITapGestureRecognizer(target: self, action: #selector(profilePressed))
        profile.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(profile)
        profileImage.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesref = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likes.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
            
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 5 * 1024 * 1024, completion: {(data, error) in
                if error != nil {
                    print("TODD: Unable to download image from Firebase Storage")
                } else {
                    print("TODD: Image downloaded from Firebase Storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImage.image = UIImage(named: "empty-heart")
            } else {
                self.likesImage.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesref.setValue(true)
            } else {
                self.likesImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesref.removeValue()
            }
        })
        
    }
    func profilePressed(sender: Any) {
        print("TODD: Pressed")
        storyBoard = UIStoryboard(name: "Main", bundle: nil)
        print("TODD: \(storyBoard)")
        controller = storyBoard.instantiateViewController(withIdentifier: "FeedVC")
        print("TODD: \(controller)")
        //controller.navigationController?.pushViewController(controller, animated: true)
        //controller.navigationController?.performSegue(withIdentifier: "toProfileVC", sender: nil)
        //controller.performSegue(withIdentifier: "toProfileVC", sender: nil)
        //controller.profilePressed(sender: sender)
        //print("\(controller.performSegue(withIdentifier: "toProfileVC", sender: sender))")
    }

}
