//
//  UberProvider.swift
//  Rebu
//
//  Created by Oisín Lavery on 5/4/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import Foundation
import Moya

let UberProvider = MoyaProvider<UberTarget>(endpointClosure: endpointClosure, plugins: [
//    NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)
])

let endpointClosure = { (target: UberTarget) -> Endpoint<UberTarget> in

    let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
    
    return Endpoint(URL: url, sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters,
                    httpHeaderFields: ["Authorization": "Bearer \(UberAuth.sharedInstance.oauth2.accessToken!)"])
}

enum UberTarget {
    case Me
}

extension UberTarget: TargetType {

    var baseURL: NSURL { return NSURL(string: "https://sandbox-api.uber.com")! }

    var path: String {
        switch self {
        case .Me:
            return "/v1/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .Me:
            return .GET
        }
    }

    var parameters: [String: AnyObject]? {
        switch self {
        case .Me:
            return nil
        }
    }

    var sampleData: NSData {
        switch self {
        case .Me:
            return  "Half measures are as bad as nothing at all".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

private func JSONResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData =  try NSJSONSerialization.dataWithJSONObject(dataAsJSON, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}