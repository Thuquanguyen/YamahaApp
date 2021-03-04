//
//  SignInWithAccountVC.swift
//  YTeThongMinh
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

class SignInWithAccountVC: UIViewController {

    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.isHidden = true
       
        // Do any additional setup after loading the view.
    }

    @IBAction func actionRegister(_ sender: Any) {
        
        let vc = RegisterVC()
        vc.isBack = false
        self.push(vc)
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        
        let email = UserDefaults.standard.string(forKey: "email")
        let pass = UserDefaults.standard.string(forKey: "password")
        if tfPhone.text == email && tfPass.text == pass{
            indicatorView.isHidden = false
            indicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.indicatorView.isHidden = true
                self.indicatorView.stopAnimating()
                AppDelegate.shared.makeHome()
            }
           }else{
            let alert = UIAlertController(title: "Warning", message: "Account or password is incorrect!\nPlease try again!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           }

    }
}

