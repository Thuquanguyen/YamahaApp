//
//  HighlightModel.swift
//  BusinessAds
//
//  Created by Apple on 3/2/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class HighlightModel {
    var title: String?
    var image: String?
    var content: String?
    
    init() {
    }
    
    init(title: String,image: String, content: String) {
        self.title = title
        self.image = image
        self.content = content
    }
}
