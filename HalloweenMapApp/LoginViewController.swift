//
//  LoginViewController.swift
//  HalloweenMapApp
//
//  Created by Suhas N on 7/22/21.
//

import Foundation
import AuthenticationServices
import GoogleSignIn
class LoginViewController: UIViewController {
    var loginProviderStackView: UIStackView!
    let buffer: CGFloat = 10
    var signInButton: GIDSignInButton!
    var signOutButton: UIButton!
    
    let signInConfig = GIDConfiguration.init(clientID: "768235434695-q2fbmmmiidn87jcbe6gu4uh564repgnb.apps.googleusercontent.com")
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loginProviderStackView = UIStackView(frame: bufferedRect(x:0,y:100 ,width: view.frame.maxX,height: 100))
        loginProviderStackView.axis = .vertical
        self.view.addSubview(loginProviderStackView)
        let backbutton = UIButton(frame: bufferedRect(x:0,y:view.frame.maxY-100 ,width: view.frame.maxX,height: 100))
        backbutton.setTitle("Back", for: .normal)
        backbutton.backgroundColor = .black
        backbutton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(backbutton)
       
        signInButton = GIDSignInButton()
        signInButton.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(signInButton)
        
        
    }
    @objc func signIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "LaunchView") as! ViewController
            homeView.modalPresentationStyle = .fullScreen
            homeView.user = UserProfile(emailAddress: (user?.profile!.email)!)
            self.present(homeView, animated: true)
        }
    }

    @objc func buttonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func bufferedRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect{
        return CGRect(x: x+buffer, y: y+buffer, width: width-2*buffer, height: height-2*buffer)
    }
}

