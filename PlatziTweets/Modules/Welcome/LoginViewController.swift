//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Jose Octavio on 14/08/20.
//  Copyright © 2020 Jose Octavio. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

//Crear nuestro propio color que funcione con dark mode
/* extension UIColor {
    static let customGreen : UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor { ( trait: UITraitCollection) -> UIColor in
                if trait.userInterfaceStyle == .dark {
//                    aqui es dark mode
                    return .white
                } else {
//                    aqui estamos en light mode
                    return .green
                }
            }
        } else {
//            aqui es menor de iOS 13
            return .green
        }
    }()
}
*/

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailSwitch: UISwitch!
    
    
//    MARK: IBActions
    
    
    @IBAction func loginButtonAction() {
        view.endEditing(true)
        performLogin()
        
    }
    
    
    private let emailKey = "email-key"
    private let storage = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
setupUI()
        
        
        if let storedEmail = storage.string(forKey: emailKey){
            emailTextField.text = storedEmail
            emailSwitch.isOn = true
        }else{
            emailSwitch.isOn = false
        }
        
    }
    
    //MARK: - Private methods
    
    private func setupUI(){
        loginButton.layer.cornerRadius = 25
       /* loginButton.textInputMode = UIColor.black
        loginButton.backgroundColor = UIColor.customGreen
        if #available(iOS 13.0, *) {
            //overrideUserInterfaceStyle = .unspecified
        }*/
    }
    private func performLogin(){
        guard let email = emailTextField.text, !email.isEmpty else{
            // MARK: - Esto es para dar notificacion si se equivoca
            NotificationBanner(title: "Error", subtitle: "Specify an e-mail", style: .warning).show()
            
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else{
                   // MARK: - Esto es para dar notificacion si se equivoca
                   NotificationBanner(title: "Error", subtitle: "Specify a password", style: .warning).show()
                   
                   return
               }
//        Crear request
        let request = LoginRequest(email: email, password: password)
        //Iniciamos la carga

        SVProgressHUD.show()

//        Llamar a librería de red
       SN.post(endpoint: Endpoints.login,
               model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in

                SVProgressHUD.dismiss()

                switch response {
                        case .success( let user):
                        NotificationBanner(subtitle: "Welcome \(user.user.names)", style: .success).show()


                        if self.emailSwitch.isOn {
                                    //                De esta manera guardamos valores con llave y valor en los user defaults
                            self.storage.set(email, forKey: self.emailKey)
                                                          }else{
                            self.storage.removeObject(forKey: self.emailKey)
                                                          }
                            
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
//    performSegue(withIdentifier: "showHome", sender: nil)
        
//        Iniciar sesión aquí
    }
                 
}
