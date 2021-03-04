//
//  InfoAccountAPI.swift
//  YTeThongMinh
//
//  Created by QuanNH on 6/1/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class InfoAccountAPI: APIOperation<InfoAccountResponse> {
    init(loginName: String, phone: String) {
        var params: [String: Any] = [:]
        params["login_name"] = loginName
        params["phone_number"] = phone
        let rawText = params.jsonString ?? ""
        super.init(request: APIRequest(name: "Send OTP ▶︎ ",
                                       path: "api/v0/auth/otp",
                                       method: .put,
                                       expandedHeaders: ["Content-Type":"application/json"],
                                       parameters: .raw(rawText)))
    }
}

struct InfoAccountResponse: APIResponseProtocol {
    
    // Variable from response data
    
    var errors: APIErrorsModel?
    
    init(json: JSON) {
        errors = APIErrorsModel(json: json["errors"])
        
        
    }
}

