/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    func displayAlert(title: String, message: String){
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
            
        }
    
var signUpMode = true
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var isDriverSwitch: UISwitch!
    @IBOutlet weak var RiderLabel: UILabel!
    
    @IBOutlet weak var DriverLabel: UILabel!
  
    @IBOutlet weak var SignupOrLoginButton: UIButton!
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        
        if UsernameTextField.text == "" || PasswordTextField.text == ""{
            displayAlert(title: "Error in form", message: "username and password are required")
        }
        else{
            
            if signUpMode {
                
                let user = PFUser()
                user.username = UsernameTextField.text
                user.password = PasswordTextField.text
                
                user["isDriver"] = isDriverSwitch.isOn
                
                user.signUpInBackground(block: {(success, error) in
                
                    if let error = error{
                        var displayedErrorMessage = "Please try again later"
                        
                        if let parseError = ((error as Any) as! NSError).userInfo["error"] as? String{
                            
                            displayedErrorMessage = parseError
                            
                        }
                        
                        self.displayAlert(title: "sign up failed", message: displayedErrorMessage)
                    }
                    
                    else{
                        print ("Sign Up Successfuel")
                        
                        if let isDriver = PFUser.current()?["isDriver"] as? Bool{
                            
                            if isDriver {
                            
                        }
                        
                        else{
                            
                              self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                            
                        }
                        
                    }
                    
                    }
                
                
                })
                
                
            } else{
                
                PFUser.logInWithUsername(inBackground: UsernameTextField.text!, password: PasswordTextField.text!, block: { (user, error) in
                    
                    
                    if let error = error{
                        var displayedErrorMessage = "Please try again later"
                        
                        if let parseError = ((error as Any) as! NSError).userInfo["error"] as? String{
                            
                            displayedErrorMessage = parseError
                            
                        }
                        
                        self.displayAlert(title: "Login  failed", message: displayedErrorMessage)
                    }
                    
                    else{
                        print ("Log In Successfull")
                        
                        if let isDriver = PFUser.current()?["isDriver"] as? Bool{
                            
                            if isDriver {
                                
                            }
                                
                            else{
                                
                                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                                
                            }
                            
                        }

                    }
                    
                    
                })
                
            }
        
        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let isDriver = PFUser.current()?["isDriver"] as? Bool{
            
            if isDriver {
                
            }
                
            else{
                
                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                
            }
            
        }

    }
    
    @IBOutlet weak var signupSwitchButton: UIButton!
    
    @IBAction func switchSignupMode(_ sender: Any) {
        
        if signUpMode{
            
            SignupOrLoginButton.setTitle("log In", for: [])
            
            signupSwitchButton.setTitle("Switch to Log Out", for: [])
            signUpMode = false
            
            
            isDriverSwitch.isHidden = true
            DriverLabel.isHidden = true
            RiderLabel.isHidden = true
            
            
            
            
        }
        
        else{
            
            SignupOrLoginButton.setTitle("Sign Up", for: [])
            
            signupSwitchButton.setTitle("Switch To Log In", for: [])
            signUpMode = true
            
            isDriverSwitch.isHidden = false
            DriverLabel.isHidden = false
            RiderLabel.isHidden = false

            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let testObject = PFObject(className: "TestObject2")
        
        testObject["foo"] = "bar"
        
        testObject.saveInBackground { (success, error) -> Void in
            
            // added test for success 11th July 2016
            
            if success {
                
                print("Object has been saved.")
                
            } else {
                
                if error != nil {
                    
                    print (error)
                    
                } else {
                    
                    print ("Error")
                }
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
