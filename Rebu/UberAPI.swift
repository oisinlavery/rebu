//
//  UberAPI.swift
//  Rebu
//
//  Created by Oisín Lavery on 5/10/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

enum UberAPIEndpoints {
    case Me
    case History
    case Places(id: Int)
}

class UberAPI {

    static let sharedInstance = UberAPI()

    let disposeBag = DisposeBag()
    var token: String!
    let baseUrlString = "https://sandbox-api.uber.com"

    init() {

    }

    func rx_get(endpoint: UberAPIEndpoints) -> Observable<AnyObject> {

        var path: String!

        switch endpoint {
        case .Me:
            path = "/v1/me"
        case .History:
            path = "/v1.2/history"
        case .Places(let id):
            path = "/v1/places/\(id)"
        }

        let url = baseUrlString + path

        return Alamofire.request(.GET, url, headers: ["Authorization": "Bearer \(UberAuth.sharedInstance.oauth2.accessToken!)"])
            .rx_JSON()
    }

}

//let parameters = [
//    "server_token": "36jtHeNaS1go4_uTigIyCP-KM7P6SBrTA6PaNye_",
//    "latitude": "37.775818",
//    "longitude": "-122.418028",
//]
//
//RxAlamofire.request(.GET, "\(apiUrl)/v1/products", parameters: parameters).responseJSON { response in
//
//    if let value = response.result.value {
//        let json = JSON(value)
//        print(json)
//    }
//}