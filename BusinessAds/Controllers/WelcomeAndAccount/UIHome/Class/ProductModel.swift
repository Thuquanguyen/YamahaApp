//
//  TiktokModel.swift
//  CreateUI
//
//  Created by ThuNQ on 10/14/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProductModel: Codable {
    var id : Int = 0
    var type: String = ""
    var title: String = ""
    var image: String = ""
    var budget: Double = 0
    var targeting: String = ""
    var avatar: Data = Data()
    
    init() {
    }
    
    init(id: Int,type:String, title: String, budget: Double, targeting: String, avatar: Data) {
        self.id = id
        self.type = type
        self.title = title
        self.budget = budget
        self.targeting = targeting
        self.avatar = avatar
    }
}
