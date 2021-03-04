//
//  LoginAPI.swift
//  ATMCard
//
//  Created by Nguyen Huu Quan on 04/07/2019.
//  Copyright © 2019 quannh. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseCore
import FirebaseMessaging


class LoginAPI: APIOperation<LoginResponse> {
    init(userName: String?, password: String?) {
        let deviceName = UIDevice.current.name
        let deviceID = UIDevice.current.identifierForVendor?.uuidString

        var params: [String: Any] = [:]
        params["login_name"] = userName
        params["password"] = password ?? ""
        params["role"] = APIConfiguration.roleApp
        params["device_name"] = deviceName
        params["mac"] = deviceID
        
        super.init(request: APIRequest(name: "Login ▶︎ ",
                                       path: "api/v0/auth/login",
                                       method: .post,
                                       expandedHeaders: ["Content-Type":"application/json"],
                                       parameters: .raw(params.jsonString ?? "")))
    }
}

struct LoginResponse: APIResponseProtocol {
    
    // Variable from response data
    var state: AccountState?
    var code: Int?
    var name: String?
    var phoneNumber: String?
    
    var errCode: Int?
    var httpCode: Int?
    
    init(json: JSON) {
        errCode = json["errors"]["httpResponseError"]["err_code"].int
        httpCode = json["errors"]["httpResponseError"]["http_code"].int
        code = json["code"].int
        name = json["name"].string
        state = AccountState(rawValue: json["data"]["state"].stringValue)
        SharedData.accountState = state
        phoneNumber = json["data"]["phone_number"].string
        
        let data = json["data"]
        SharedData.accessToken = data["token"].string
        SharedData.freshToken = data["refreshToken"].string
        SharedData.userID = data["id"]["patient_id"].int

        let dictionUser = decode(jwtToken: SharedData.accessToken ?? "")
        let jsonUser = JSON(dictionUser)
        SharedData.loginName = jsonUser["login_name"].string
        SharedData.accountId = jsonUser["account_id"].int
    }
    
    func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        if segments.count > 2 {
            return decodeJWTPart(segments[1]) ?? [:]
        } else if segments.count > 1 {
            return decodeJWTPart(segments[0]) ?? [:]
        } else {
            return [:]
        }
    }
    
    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
        }
        
        return payload
    }
}


enum AccountState: String {
    case INACTIVE, VERIFIED, ACTIVE, PENDING, NONE
}
