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
    case Products
    case Product
    case PriceEstimates
    case TimeEstimates
    case History
    case Me
    case RequestCurrent
    case RequestDetails
    case RequestMap
    case RequestReceipt
    case Places
    case PaymentMethods
}

// UBER API overview: https://developer.uber.com/docs/api-overview

class UberAPI {

    static let sharedInstance = UberAPI()

    let baseUrlString = "https://sandbox-api.uber.com"
    let serverToken = "36jtHeNaS1go4_uTigIyCP-KM7P6SBrTA6PaNye_"

    let disposeBag = DisposeBag()
    var token: String!

    init() {}

    func rx_request(endpoint: UberAPIEndpoints, method: Alamofire.Method = .GET, id: String = "", parameters: [String : NSObject] = [:]) -> Observable<AnyObject> {

        let headers = [
            "Authorization": "Bearer \(UberAuth.sharedInstance.oauth2.accessToken!)",
            "Content-Type": "application/json"
        ]

        var path: String!

        switch endpoint {
        case .Products:
            path = "/v1/products"
        case .Product:
            path = "/v1/product/\(id)"
        case .PriceEstimates:
            path = "/v1/estimates/price"
        case .TimeEstimates:
            path = "/v1/estimates/time"
        case .History:
            path = "/v1.2/history"
        case .Me:
            path = "/v1/me"
        case .RequestCurrent:
            path = "/v1/requests/current"
        case .RequestDetails:
            path = "/v1/requests/\(id)"
        case .RequestMap:
            path = "/v1/requests/\(id)/map"
        case .RequestReceipt:
            path = "/v1/requests/\(id)/receipt"
        case .Places:
            path = "/v1/places/\(id)"
        case .PaymentMethods:
            path = "/v1/payment-methods"
        }

        let urlString = baseUrlString + path

        let request = Alamofire
            .request(method, urlString, parameters: parameters, headers: headers)
//            .responseJSON { response in
//                print(response)
//            }
            .rx_JSON()

//        debugPrint(request)

        return request
    }

    func rx_post(requestId: String) -> Observable<AnyObject> {

//        let path = "/v1/requests"
        let path = "/v1/sandbox/requests/\(requestId)"
        let urlString = baseUrlString + path
        let headers = [
            "Authorization": "Bearer \(UberAuth.sharedInstance.oauth2.accessToken!)",
            "Content-Type": "application/json"
        ]

//        let parameters = ["start_place_id": "home"]
        let parameters = ["status": "accepted"]

        let request = Alamofire
            .request(.POST, urlString, parameters: parameters, encoding: .JSON, headers: headers)
            .responseJSON { response in
                print(response)
            }
            .rx_JSON()

        debugPrint(request)

        return request
    }
}
