//
//  RegisterVC.swift
//  YTeThongMinh
//
//  Created by Apple on 10/8/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import CountryPickerView
import Firebase
import FirebaseDatabase

class RegisterVC: UIViewController {
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageCheckBoxConfirm: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var viewErrorEmail: UIView!
    @IBOutlet weak var viewErrorPassWord: UIView!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorPassword: UILabel!
    @IBOutlet weak var labelErrorConfirm: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfFirstname: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfLastname: UITextField!
    var isBack = true
    
    var isConfirm: Bool = false
    {
        didSet{
            imageCheckBoxConfirm.image = UIImage(named: isConfirm ? "icon_check" : "icon_uncheck")
        }
    }
    
    var year: Int = 0
    var isEmail = false,isPhone = false,isPass = false,isConfirmPass = false
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.isHidden = isBack
        btnCreateAccount.isUserInteractionEnabled = false
        indicatorView.isHidden = true
        initView()
        initTextField()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        isConfirm = !isConfirm
        labelErrorConfirm.isHidden = isConfirm
        checkEnableButton()
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        let vc = SignInWithAccountVC()
        self.push(vc)
    }
    
    @IBAction func actionCreateAccount(_ sender: Any) {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.indicatorView.isHidden = true
            self.indicatorView.stopAnimating()
            let defaults = UserDefaults.standard
            defaults.set(self.tfEmail.text, forKey: "email")
            defaults.set(self.tfPassword.text, forKey: "password")
            defaults.set("\(self.tfLastname.text ?? "") \(self.tfFirstname.text ?? "")", forKey: "username")
            defaults.set(true, forKey: "register")
            defaults.synchronize()
            self.checkFirebase()
        }
    }
}

extension RegisterVC{
    
    func checkFirebase(){
        ref = Database.database().reference()
        self.ref.child("status").observeSingleEvent(of: .value, with: { (snapshot) in
            if let status = snapshot.value as? Bool {
                if status{
                    AppDelegate.shared.makeHome()
                }else{
                    let vc = SignInWithAccountVC()
                    self.push(vc)
                }
            }
        })
    }
    
    private func initView(){
        tableView.tableHeaderView = headerView
        let date = Date()
        year = Calendar.current.component(.year, from: date)
    }
    
    func initTextField(){
        tfEmail.addTarget(self, action: #selector(tfEmailDidChange(_:)), for: .editingChanged)
        tfPassword.addTarget(self, action: #selector(tfPasswordDidChange(_:)), for: .editingChanged)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func checkEnableButton(){
        if isEmail && isPass && isConfirm{
            btnCreateAccount.isEnabled = true
            btnCreateAccount.isUserInteractionEnabled = true
            btnCreateAccount.backgroundColor = UIColor("FF9800")
        }else{
            btnCreateAccount.isEnabled = false
            btnCreateAccount.isUserInteractionEnabled = false
            btnCreateAccount.backgroundColor = UIColor("03DAC5")
        }
    }
}

extension RegisterVC{
    @objc func tfYearDidChange(_ textField: UITextField){
        if textField.text?.count ?? 0 > 4{
            textField.deleteBackward()
        }
        
    }
    
    @objc func tfMonthDidChange(_ textField: UITextField){
        if textField.text?.count ?? 0 > 2{
            textField.deleteBackward()
        }
    }
    
    @objc func tfDayDidChange(_ textField: UITextField){
        if textField.text?.count ?? 0 > 2{
            textField.deleteBackward()
        }
    }
    
    @objc func tfEmailDidChange(_ textField: UITextField){
        if !isValidEmail(textField.text ?? "")
        {
            isEmail = false
            viewErrorEmail.isHidden = false
            labelErrorEmail.isHidden = false
        }else{
            isEmail = true
            viewErrorEmail.isHidden = true
            labelErrorEmail.isHidden = true
        }
        checkEnableButton()
    }
    
    @objc func tfPasswordDidChange(_ textField: UITextField){
        if textField.text?.count ?? 0 < 6{
            isPass = false
            viewErrorPassWord.isHidden = false
            labelErrorPassword.isHidden = false
        }else{
            isPass = true
            viewErrorPassWord.isHidden = true
            labelErrorPassword.isHidden = true
        }
        checkEnableButton()
    }
}
