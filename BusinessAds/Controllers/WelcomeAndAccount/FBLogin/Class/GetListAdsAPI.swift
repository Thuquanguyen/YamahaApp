//
//  GetListAdsAPI.swift
//  BusinessAds
//
//  Created by Apple on 11/16/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetListAdsAPI: APIOperation<GetListAdsResponse> {
    init(tokken: String = "") {
        super.init(request: APIRequest(name: "get all acc",
                                       path: "me?fields=adaccounts{balance,amount_spent}&access_token=\(tokken)",
                                       method: .get,
                                       expandedHeaders: ["Content-Type":"application/json"],
                                       parameters: .body([:]),enviroment: .facebookPort))
    }
}

struct GetListAdsResponse: APIResponseProtocol {
    // Variable from response data
    var errors: APIErrorsModel?
    var listFB = [FBModel]()
    
    init(json: JSON) {
        errors = APIErrorsModel(json: json["errors"])
        if let data = json["adaccounts"]["data"].array{
            for item in data{
                listFB.append(FBModel(json: item))
            }
        }
    }
}
