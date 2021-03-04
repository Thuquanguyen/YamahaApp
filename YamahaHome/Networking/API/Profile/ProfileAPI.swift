//
//  ProfileAPI.swift
//  YTeThongMinh
//
//  Created by DatTV on 6/3/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ProfileAPI: APIOperation<ProfileResponse> {
    init(patientId: Int) {
        super.init(request: APIRequest(name: "Lấy danh thong tin bn",
                                       path: "api/v0/patient/personalinfo/\(patientId.string)",
            method: .get,
            parameters: .body([:]),
            enviroment: APIEnviroment.jsonEnviroment.set(encoding: APIConfiguration.encoding)))
    }
    
    // update profile
    init(patientId: Int, patient: PatientModel) {
        var params = patient.toParams()
        if SharedData.accountState == AccountState.VERIFIED {
            params["is_first_update"] = true
        }
        super.init(request: APIRequest(name: "cap nha ho so benh nhan",
                                       path: "api/v0/patient/personalinfo/\(patientId.string)",
            method: .put,
            parameters: .body(params),
            enviroment: APIEnviroment.jsonEnviroment))
    }
}

struct ProfileResponse: APIResponseProtocol {
    
    var patient = PatientModel()
    var stateAccount: AccountState?
    var code: Int?
    var errors: APIErrorsModel?
    var json: JSON?
    
    init(json: JSON) {
        errors = APIErrorsModel(json: json["errors"])
        code = json["code"].int
        if let typeActive = json["data"].string , let state = AccountState(rawValue: typeActive) {
            stateAccount = state
        }
        patient = PatientModel(fromJson: json["data"])
        self.json = json["data"]
    }
}

class BaseGetListAPI<T: BaseModel> : APIOperation<BaseGetListResponse<T>> {
    init(api: APIPath, params: [String: Any] = [:], pageNumber: Int? = 1) {
        var body = params
        body["page_size"] = 15
        body["page_num"] = pageNumber
        super.init(request: APIRequest(name: "BaseGetListAPI",
                                       path: api.rawValue,
            method: .get,
            parameters: .body(body),
            enviroment: APIEnviroment.default))
    }
    
    enum APIPath: String {
        case hopital = "api/v0/staticdata/hospital/"
        case specialty = "api/v0/staticdata/specialty/"
        case degree = "api/v0/staticdata/degreetype/"
        case academic = "api/v0/staticdata/academic/"
        case qualification = "api/v0/staticdata/qualification/"
        case listBloodPressure = "data/v0/healthservice/measurement"
        case descriptionBloodPressure = "api/v0/staticdata/measuresymptom/"
        case typeRemind = "api/v0/staticdata/remindertype/"
    }
}

struct BaseGetListResponse<T: BaseModel>: APIResponseProtocol {
    
    var data: [T] = []
    
    init(json: JSON) {
        
        for (index, item) in data.enumerated() {
            if item.name == "Khác" {
                data.remove(at: index)
                data.append(item)
                break
            }
        }
        data = json["data"].arrayValue.map {
            let t = T.init()
            t.setupData(json: $0)
            return t
        }
    }
}

class BaseModelRequestAPI<T: BaseModel> : APIOperation<BaseModelRequestResponse<T>> {
    init(api: APIPath, method: HTTPMethod = .get, params: [String: Any] = [:], endUrl: String? = nil) {
        super.init(request: APIRequest(name: "Base Model Request",
                                       path: api.rawValue + (endUrl ?? ""),
            method: method,
            parameters: .body(params),
            enviroment: APIEnviroment.jsonEnviroment))
    }
    
    enum APIPath: String {
        case healthService = "data/v0/healthservice/measurement/"
    }
}

struct BaseModelRequestResponse<T: BaseModel>: APIResponseProtocol {
    
    var data = T.init()
    var code: Int?
    
    init(json: JSON) {
        code = json["code"].int
        data.setupData(json: json["data"])
    }
}

class ObjectRequestAPI<T> : APIOperation<ObjectRequestResponse<T>> {
    init(api: APIPath, method: HTTPMethod = .get, params: [String: Any] = [:], endUrl: String? = nil) {
        super.init(request: APIRequest(name: "Json request",
                                       path: api.rawValue + (endUrl ?? ""),
            method: method,
            parameters: .body(params),
            enviroment: APIEnviroment.jsonEnviroment))
    }
    
    enum APIPath: String {
        case rattingDoctor = "api/v0/patient/advisory/rating" // method put
        case uploadAvatar = "api/v0/doctor/avatar"
        case deleteHealthService = "data/v0/healthservice/measurement/multi"  // method delete ids = arrray
    }
}

struct ObjectRequestResponse<T>: APIResponseProtocol {
    
    var data: T?
    var code: Int?
    
    init(json: JSON) {
        code = json["code"].int
        data = json["data"].rawValue as? T
    }
}


class DownloadAPI : APIOperation<DownloadResponse> {
    init(file: URL, url: String, method: HTTPMethod = .get, params: [String: Any] = [:], baseUrl: String? = nil) {
        let enviroment = APIEnviroment.emptyBaseEnviroment
        if let base = baseUrl {
            enviroment.set(baseUrl: base)
        }
        super.init(request: APIRequest(name: "download file",
                                       path: url,
            method: method,
            parameters: .download(file: file, parameters: params),
            enviroment: APIEnviroment.emptyBaseEnviroment))
    }
}

struct DownloadResponse: APIResponseProtocol {
        
    init(json: JSON) {
        
    }
}

class UploadFileAPI : APIOperation<UploadFileResponse> {
    init(files: [String : [URL]], api: APIPath, method: HTTPMethod = .post, params: [String: Any] = [:]) {
        super.init(request: APIRequest(name: "upload file",
                                       path: api.rawValue,
            method: method,
            parameters: .multipartFilesAndParams(files: files, parameters: params),
            enviroment: APIEnviroment.downloadEnviroment))
    }
    
    enum APIPath: String {
         case uploadAvatar = "api/v0/uploads/avatar"
         case certificate = "api/v0/uploads/certificates"
         case healthMeasurement = "api/v0/health-measurement/image"
     }
}

struct UploadFileResponse: APIResponseProtocol {
        
    init(json: JSON) {
        
    }
}


