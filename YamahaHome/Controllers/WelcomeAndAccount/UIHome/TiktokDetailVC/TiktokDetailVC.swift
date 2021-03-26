//
//  AdsDetailVC.swift
//  CreateUI
//
//  Created by ThuNQ on 10/14/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import UIKit

class TiktokDetailVC: UIViewController {

    @IBOutlet weak var naviBar: CustomNaviBar!{
        didSet{
            naviBar.title = "Campaign Detail"
        }
    }
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelContenType: UILabel!
    @IBOutlet weak var labelBudget: UILabel!
    
    var tiktok = TiktokModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.buttonBack.didTap = {
            self.pop()
        }
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width / 2
        if let image = UIImage(data: tiktok.avatar as Data)
        {
            self.imageAvatar.image = image
        }
        labelContenType.text = tiktok.title
        labelBudget.text = "\(tiktok.content)"
    }
}
