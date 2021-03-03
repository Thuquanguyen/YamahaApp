//
//  ProfileVC.swift
//  ChatApplication-DEV
//
//  Created by Apple on 2/7/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileVC: UIViewController {

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var naviBar: CustomNaviBar!
    {
        didSet{
            naviBar.title = "Infomation"
        }
    }
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        imageAvatar.setCorner(imageAvatar.bounds.width/2)
        initData()
        naviBar.buttonBack.didTap = {
            self.pop()
        }
    }

    @IBAction func actionLogout(_ sender: Any) {
        logout()
    }
}

extension ProfileVC{
    private func initData(){
        if let name = UserDefaults.standard.value(forKey:"name"), let email = UserDefaults.standard.value(forKey:"email"){
            labelName.text = "Tên đăng nhập : \(name)"
            labelEmail.text = "Email :\(email)"
        }
    }
    
    private func logout(){
        UserDefaults.standard.setValue(nil, forKey: "email")
        UserDefaults.standard.setValue(nil, forKey: "name")
        let defaults = UserDefaults.standard
        defaults.set([], forKey: "data_tiktok")
        defaults.set(false, forKey: "login_check")
        defaults.synchronize()
        let vc = SignInWithAccountVC()
        self.push(vc)
    }
}
