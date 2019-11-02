//
//  ViewController.swift
//  onTheMapVer2
//
//  Created by Hema on 9/23/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginViaFaceBookButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTextField(emailTextField, text: "")
        configureTextField(passwordTextField, text: "")
        //subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.becomeFirstResponder()
        
    }
    
    let onTheMapTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.white,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 25)!,
        NSAttributedString.Key.strokeWidth: -1.0
    ]
    
    func configureTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.textAlignment = .center
        //textField.delegate = textFieldDelegate
        textField.defaultTextAttributes = onTheMapTextAttributes
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        OnTheMapClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
       
        setLoggingIn(false)

    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
               OnTheMapClient.getUserName(completion: completeLogin(success:error:))
         
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let aURL:String! = "https://auth.udacity.com/sign-up"
        print(aURL as Any)
        let bUrl:String! = aURL
        print(bUrl as Any)
        detailController.webData = aURL
        self.present(detailController, animated: true, completion: nil)
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    

    func completeLogin(success: Bool, error: Error?) {

        if success {
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        //show(alertVC, sender: nil)
        self.present(alertVC, animated: true,  completion: nil)
    
    }
    
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn

    }

}

