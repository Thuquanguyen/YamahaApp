//
//  NewsEventCell.swift
//  BusinessAds
//
//  Created by Apple on 3/2/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class NewsEventCell: UITableViewCell {

    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(data: NewsEventModel){
        imageContent.image = UIImage(data.image)
        labelTitle.text = data.title
        labelSubTitle.text = data.startDate
        labelSubTitle.text = data.subTitle
    }
    
}
