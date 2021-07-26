//
//  InitialViewController.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/28/21.
//

import Foundation
import UIKit
import GoogleMaps
class InitialViewController: UIViewController {
    
    let buffer: CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeOwnerButton = UIButton(frame: bufferedRect(x:0,y:0 ,width: view.frame.maxX,height: view.frame.maxY/2))
        homeOwnerButton.setTitle("I am a candy giver", for: .normal)
        homeOwnerButton.backgroundColor = .black
        homeOwnerButton.addTarget(self, action: #selector(homeButtonClicked(_:)), for: .touchUpInside)
        self.view.addSubview(homeOwnerButton)
        
        let trickButton = UIButton(frame: bufferedRect(x:0,y:view.frame.maxY/2 ,width: view.frame.maxX,height: view.frame.maxY/2))
        trickButton.setTitle("I am a trick-or-treater", for: .normal)
        trickButton.backgroundColor = .black
        trickButton.addTarget(self, action: #selector(trickButtonClicked(_:)), for: .touchUpInside)
        self.view.addSubview(trickButton)
       
    }
    
    @objc func homeButtonClicked(_ sender: Any) {
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
        homeView.modalPresentationStyle = .fullScreen
        present(homeView, animated: true)
    }
    @objc func trickButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func bufferedRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect{
        return CGRect(x: x+buffer, y: y+buffer, width: width-2*buffer, height: height-2*buffer)
    }
}
