//
//  NewsEventModel.swift
//  BusinessAds
//
//  Created by Apple on 3/2/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsEventModel {
    var title: String?
    var subTitle: String?
    var image: String?
    var startDate: String?
    var content: String?
    
    init() {
    }
    
    init(title: String, subTitle: String,image: String,startDate: String,content: String) {
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.startDate = startDate
        self.content = content
    }
}
