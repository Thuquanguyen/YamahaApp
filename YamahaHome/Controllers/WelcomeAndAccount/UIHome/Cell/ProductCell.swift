//
//  ProductCell.swift
//  BusinessAds
//
//  Created by Apple on 2/28/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(data: ProductModel){
        labelName.text = data.title
        imageContent.image = UIImage(data.image)
    }
}
