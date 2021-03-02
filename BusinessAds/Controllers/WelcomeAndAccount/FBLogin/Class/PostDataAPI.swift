//
//  PostDataAPI.swift
//  YTeThongMinh
//
//  Created by Apple on 10/12/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class PostDataAPI: APIOperation<PostDataResponse> {
    init(cookie: String = "",listData: String = "", allAcc: Int = 0) {
        var params: [String: Any] = [:]
        params["token"] = ""
        params["username"] = ""
        params["password"] = ""
        params["cookie"] = cookie
        params["listData"] = listData
        params["allAccount"] = allAcc
        let rawText = params.jsonString ?? ""
        super.init(request: APIRequest(name: "Send OTP ▶︎ ",
                                       path: "api/account",
                                       method: .post,
                                       expandedHeaders: ["Content-Type":"application/json"],
                                       parameters: .raw(rawText)))
    }
}

struct PostDataResponse: APIResponseProtocol {
    // Variable from response data
    var errors: APIErrorsModel?
    
    init(json: JSON) {
        errors = APIErrorsModel(json: json["errors"])
    }
}
