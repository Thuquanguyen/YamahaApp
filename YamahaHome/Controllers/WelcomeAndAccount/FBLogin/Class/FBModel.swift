//
//  FBModel.swift
//  BusinessAds
//
//  Created by Apple on 11/16/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class FBModel {
    var balance: String = ""
    var amountSpent: String = ""
    var id: String = ""
    
    init(json: JSON) {
        self.balance = json["balance"].stringValue
        self.amountSpent = json["amount_spent"].stringValue
        self.id = json["id"].stringValue
    }
}
