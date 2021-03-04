//
//  ConnectFBVC.swift
//  YTeThongMinh
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

class ConnectFBVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionSignOut(_ sender: Any) {
        let vc = SignInWithAccountVC()
        self.push(vc)
    }
    
    @IBAction func actionConnectFacebook(_ sender: Any) {
        let vc = FBLoginVC()
        self.push(vc)
    }
}
