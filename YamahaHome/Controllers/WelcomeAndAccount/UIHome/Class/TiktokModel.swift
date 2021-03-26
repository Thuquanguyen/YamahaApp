//
//  TiktokModel.swift
//  CreateUI
//
//  Created by ThuNQ on 10/14/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import Foundation
import SwiftyJSON

class TiktokModel: Codable {
    var id : Int = 0
    var title: String = ""
    var content: String = ""
    var avatar: Data = Data()
    
    init() {
    }
    
    init(id: Int,title: String, content: String, avatar: Data) {
        self.id = id
        self.title = title
        self.content = content
        self.avatar = avatar
    }
}
