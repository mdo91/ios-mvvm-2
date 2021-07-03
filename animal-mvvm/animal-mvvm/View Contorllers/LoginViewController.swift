//
//  LoginViewController.swift
//  animal-mvvm
//
//  Created by Mdo on 11/05/2021.
//

import Foundation
import UIKit


class LoginViewController:UIViewController{
    //MARK: - Properties
    
    static let identifier : String = String(describing: LoginViewController.self)
    
    @IBOutlet weak var loginTypeSegmentedControl:UISegmentedControl!
    @IBOutlet weak var usernameTextField:UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    var loginType = LoginType.signUp
    lazy var viewModel = LoginViewModel()
    
    private var isFetching:Bool = false{
        didSet{
            if isFetching{
                activityIndicator.startAnimating()
                submitButton.isEnabled = false
            }else{
                activityIndicator.stopAnimating()
                submitButton.isEnabled = true
            }
        }
    }
    
    //MARK: - viewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 8
    }
    
    //MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 1:
            loginType = .signIn
            passwordTextField.textContentType = .password
        default:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        }
        
        submitButton.setTitle(loginType.rawValue, for: .normal)
    }
    
    @IBAction func textDidChanged(_ sender:UITextField){
        
        submitButton.isEnabled = usernameTextField.text?.isEmpty
            == false && passwordTextField.text?.isEmpty == false
    }
    
    @IBAction func submitButtonTapped(_ sender:UIButton){
        isFetching = true
        
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
              , username.isEmpty == false,
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              password.isEmpty == false else {
            return
        }
        
        let user = User(username: username, password: password)
        viewModel.submit(with: user, forLoginType: loginType) { (loginResult) in
            DispatchQueue.main.async {
                self.isFetching = false
                let alert: UIAlertController
                let action: ()->Void
                
                switch loginResult {
                
                case .signUpSuccess:
                    alert = self.alert(title: "success", message: loginResult.rawValue)
                    
                    action = {
                        
                        self.present(alert, animated: true)
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.loginTypeSegmentedControl.sendActions(for: .valueChanged)
                    }
                case .signInSucess:
                    action = {self.dismiss(animated: true)}
                    
                case .signUpError, .signInError:
                    alert = self.alert(title: "Error", message: loginResult.rawValue)
                    //alert = self.alert
                    action = {self.present(alert, animated: true)}
                }
                action()
            }
        }
    }
    
    private func alert(title:String, message:String) -> UIAlertController{
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default))
        return alert
    }
}
