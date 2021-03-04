//
//  AddAdsVC.swift
//  CreateUI
//
//  Created by ThuNQ on 10/13/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import UIKit
import DropDown
import Photos

class AddAdsVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var tfWebsite: UITextField!
    @IBOutlet weak var tfBudget: UITextField!
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var viewUpload: UIView!
    @IBOutlet weak var viewTargeting: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var labelTargeting: UILabel!
    
    var dropDown = DropDown()
    var dataDrop: [String] = ["Children","Engineer","Doctor","Constructor","Singer","Programer","Teacher"]
    var isWebsite: Bool = true
    var isApp: Bool = false
    var imagePicker = UIImagePickerController()
    var urlAvatar: String = ""
    var listData = [ProductModel]()
    var avatar: UIImage = UIImage(named: "") ?? UIImage()
    var updateData:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        labelTargeting.text = dataDrop[0]
        imagePicker.delegate = self
        getData()
    }
    
    private func getData(){
        if let placeData = UserDefaults.standard.data(forKey: "data_tiktok"){
            let placeArray = try! JSONDecoder().decode([ProductModel].self, from: placeData)
            self.listData = placeArray
        }
    }
    
    @objc func showInputWebsite(){
        tfWebsite.isHidden = false
        isWebsite = true
        isApp = false
    }
    
    @objc func showInputApp(){
        tfWebsite.isHidden = true
        isWebsite = false
        isApp = true
    }
    
    @IBAction func actionTargeting(_ sender: Any) {
        dropDown.dataSource = dataDrop
        dropDown.anchorView = btnDropDown
        dropDown.bottomOffset = CGPoint(x: 0, y: btnDropDown.frame.size.height)
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.labelTargeting.text = item
        }
        dropDown.show()
    }
    
    @IBAction func actionUpload(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    self.imagePicker.sourceType = .photoLibrary
                    self.imagePicker.allowsEditing = false
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func actionSend(_ sender: Any) {
        if checkSubmit(){
            let defaults = UserDefaults.standard
            let imgData = avatar.jpegData(compressionQuality: 1)
            let model = ProductModel(id: listData.count,type: isWebsite ? "Website visits" : "App installs", title: tfWebsite.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" , budget: Double(tfBudget.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0") ?? 0, targeting: labelTargeting.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", avatar: imgData ?? Data())
            listData.append(model)
            let placesData = try! JSONEncoder().encode(listData)
            defaults.set(placesData, forKey: "data_tiktok")
            defaults.synchronize()
            self.updateData?()
            self.pop()
        }else{
            let alert = UIAlertController(title: "Warning", message: "The data field marked with (*) cannot be left blank!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.pop()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageUpload.contentMode = .scaleToFill
            imageUpload.image = pickedImage
            self.avatar = pickedImage
            self.urlAvatar = "success"
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension AddAdsVC{
    private func setupUI(){
        setupBorderView(viewBorder: viewUpload)
        setupBorderView(viewBorder: viewTargeting)
        btnSend.layer.cornerRadius = 10
        imageUpload.layer.cornerRadius = 5
    }
    
    private func setupBorderView(viewBorder: UIView){
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "1D2D49")?.cgColor
    }
    
    private func checkSubmit()-> Bool{
        if tfWebsite.text?.isEmpty ?? false{
            return false
        }
        
        if tfBudget.text?.isEmpty ?? false{
            return false
        }
        
        if urlAvatar.isEmpty{
            return false
        }
        
        return true
    }
}
