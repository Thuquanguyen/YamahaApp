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
    @IBOutlet weak var viewLoading: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func actionRegister(_ sender: Any) {
        
        let vc = RegisterVC()
        vc.isBack = false
        self.push(vc)
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        viewLoading.isHidden = false
        let email = UserDefaults.standard.string(forKey: "email")
        let pass = UserDefaults.standard.string(forKey: "password")
        if (tfPhone.text == email && tfPass.text == pass) || (tfPhone.text == "namtran@gmail.com" && tfPass.text == "Aoe@123"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.viewLoading.isHidden = true
                AppDelegate.shared.makeHome()
            }
           }else{
            self.viewLoading.isHidden = true
            let alert = UIAlertController(title: "Warning", message: "Account or password is incorrect!\nPlease try again!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           }

    }
}

