//
//  PopupConnectVC.swift
//  BusinessAds
//
//  Created by Apple on 3/3/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class PopupConnectVC: UIViewController {

    var connectFB:(() -> Void)?
    var closeAction:(() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionConnectFB(_ sender: Any) {
        connectFB?()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.remove()
        closeAction?()
    }
}
