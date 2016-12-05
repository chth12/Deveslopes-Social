//
//  ViewController.swift
//  Deveslopes Social
//
//  Created by Christopher Heins on 11/28/16.
//  Copyright © 2016 Christopher Todd Heins. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("TODD: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                
                print("TODD:  User cancelled login - \(error)")
            } else {
                
                print("TODD: Sucessfully authenticated with Facebood")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
            }
            
            
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            
            if error != nil {
                
                print("TODD: Unable to authenticate wirth Firebase - \(error)")
                
            } else {
                
                print("TODD: Successfully authenticated with Firebasea")
                
            }
            
        })
        
    }
    
}

