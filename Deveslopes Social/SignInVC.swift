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

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passField: FancyField!
    @IBOutlet weak var emailField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passField.delegate = self
        

        
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
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("TODD: Email User Authenticated with Firebase")
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            
                            print("TODD: Unable to authenticate with Firebase using email")
                            
                        } else {
                            
                            print("TODD: Successfully authenticated with Firebase")
                            
                        }
                    })
                    
                }
            })
            
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.endEditing(true)
        emailField.returnKeyType = UIReturnKeyType.done
        
        passField.endEditing(true)
        passField.returnKeyType = UIReturnKeyType.done
        
        
    
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
            textField.resignFirstResponder()
            return true
        
    }
}












