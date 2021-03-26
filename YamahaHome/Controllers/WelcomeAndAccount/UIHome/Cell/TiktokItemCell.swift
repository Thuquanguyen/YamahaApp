//
//  TiktokItemCell.swift
//  CreateUI
//
//  Created by ThuNQ on 10/13/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import UIKit

class TiktokItemCell: UITableViewCell {

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelBudget: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageAvatar.layer.cornerRadius = imageAvatar.bounds.size.width  / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initData(tiktok: TiktokModel){
        if let image = UIImage(data: tiktok.avatar as Data)
        {
            self.imageAvatar.image = image
        }
        labelTitle.setTitle(title: "Name : ", content: tiktok.title)
        labelBudget.setTitle(title: "Description : ", content: "\(tiktok.content)")
    }
}
