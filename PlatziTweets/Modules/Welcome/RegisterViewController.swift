//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Jose Octavio on 14/08/20.
//  Copyright © 2020 Jose Octavio. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    //    MARK: IBActions
        
        
        @IBAction func signUpButtonAction() {
            view.endEditing(true)
            performSignUp()
            // loginSegue()
            
        }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI(){
        signUpButton.layer.cornerRadius = 25
    }
    
    private func performSignUp(){
    
        guard let email = emailTextField.text, !email.isEmpty else{
               // MARK: - Esto es para dar notificacion si se equivoca
               NotificationBanner(title: "Error", subtitle: "Specify an email", style: .warning).show()
               
               return
           }
           guard let password = passwordTextField.text, !password.isEmpty else{
                      // MARK: - Esto es para dar notificacion si se equivoca
                      NotificationBanner(title: "Error", subtitle: "Specify a password", style: .warning).show()
                      
                      return
                  }
        
     /* guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else{
            // MARK: - Esto es para dar notificacion si se equivoca
            NotificationBanner(title: "Error", subtitle: "Debes confirmar tu contraseña", style: .warning).show()
            
            return
        }*/
        
           guard let names = nameTextField.text, !names.isEmpty else{
               // MARK: - Esto es para dar notificacion si se equivoca
               NotificationBanner(title: "Error", subtitle: "Specify your name", style: .warning).show()
               
               return
           }
        //Crear request
        
        let request = RegisterRequest(email: email, password: password, names: names)
        
        //Indicar la carga al usuario
        
        SVProgressHUD.show()
        
        //Llamar al servicio 
        
        SN.post(endpoint: Endpoints.register,
                     model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
                
                        //Cerrramos la carga al usuario
                        
                      SVProgressHUD.dismiss()

            switch response {
                case .success(let user):
                    NotificationBanner(subtitle: "Welcome \(user.user.names)", style: .success).show()
            self.performSegue(withIdentifier: "showHome", sender: nil)
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                            case .error(let error):
                                return
                                            // todo lo malo :(
                                             NotificationBanner(subtitle: "Error", style: .danger).show()
                          
                            case .errorResult(let entity):
                                return
                                            // error pero no tan malo :)
                           NotificationBanner(subtitle: "Error", style: .warning).show()
                                        }
          }
        
         performSegue(withIdentifier: "showHome", sender: nil)
       }
    
}
