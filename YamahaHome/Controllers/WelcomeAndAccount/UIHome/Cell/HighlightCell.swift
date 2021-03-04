//
//  HighlightCell.swift
//  BusinessAds
//
//  Created by Apple on 3/2/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class HighlightCell: UICollectionViewCell {

    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(data: HighlightModel){
        labelName.text = data.title
        imageContent.image = UIImage(data.image)
    }
}
