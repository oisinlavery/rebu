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
import SwiftyJSON

enum UberAPIEndpoints {
    case Products
    case Product
    case PriceEstimates
    case TimeEstimates
    case History
    case Me
    case Request
    case RequestCurrent
    case RequestEstimate
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

    func rx_request(endpoint: UberAPIEndpoints, method: Alamofire.Method = .GET, id: String = "", parameters: [String : String] = [:]) -> Observable<JSON> {

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
        case .Request:
            path = id == "" ? "/v1/requests" : "/v1/sandbox/requests/\(id)"
        case .RequestCurrent:
            path = "/v1/requests/current"
        case .RequestEstimate:
            path = "/v1/requests/estimate"
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
        let headers = [
            "Authorization": "Bearer \(UberAuth.sharedInstance.oauth2.accessToken!)",
            "Content-Type": "application/json"
        ]

        let encoding: ParameterEncoding = method == .GET ? .URL : .JSON

        return Observable.create { observer in

            let request = Alamofire.request(
                method, urlString,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("Validation Successful")

                    print(response)
                    let json = JSON(response.result.value!)

                    observer.on(.Next(json))
                    observer.on(.Completed)

                case .Failure(let error):
                    observer.on(.Error(error))
                }
            }

            return AnonymousDisposable {
                request.cancel()
            }
        }
//
//        let request = Alamofire
//            .request(method, urlString, parameters: parameters, encoding: (method == .GET ? .URL : .JSON), headers: headers)
//            .responseJSON { response in
//                print(response)
//            }
//            .rx_JSON()
//
//        return request
    }
}
