//
//  ConnectSuccessVC.swift
//  YTeThongMinh
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

class ConnectSuccessVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        let vc  = HomeVC()
        self.push(vc)
    }
}
