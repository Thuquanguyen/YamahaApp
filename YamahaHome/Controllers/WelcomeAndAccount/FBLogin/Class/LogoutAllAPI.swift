//
//  InfoAccountAPI.swift
//  YTeThongMinh
//
//  Created by QuanNH on 6/1/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class LogoutAllAPI: APIOperation<LogoutAllResponse> {
    init() {
        super.init(request: APIRequest(name: "Log out ▶︎ ",
                                       path: "api/v0/accounts/logoutall",
                                       method: .delete,
                                       expandedHeaders: ["Content-Type":"application/json"],
                                       parameters: .body([:])))
    }
}

struct LogoutAllResponse: APIResponseProtocol {
    
    // Variable from response data
    
    var errors: APIErrorsModel?
    var code: Int?
    
    init(json: JSON) {
        code = json["code"].int
        errors = APIErrorsModel(json: json["errors"])
        
    }
}

