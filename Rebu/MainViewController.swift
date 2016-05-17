//
//  MainViewController.swift
//  Rebu
//
//  Created by Oisín Lavery on 5/2/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import SwiftyJSON

import GoogleMaps
import Kingfisher


class MainViewController: UIViewController, CLLocationManagerDelegate {

    let uberAuth = UberAuth.sharedInstance
    let uberAPI = UberAPI.sharedInstance

    let locationManager = CLLocationManager()

    let disposeBag = DisposeBag()

    @IBOutlet var mapView: GMSMapView!

    @IBOutlet var driverImageView: UIImageView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var fullName: UILabel!

    @IBOutlet var currentButton: UIButton!
    @IBOutlet var requestButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        uberAuth.rx_hasToken
        .subscribeNext { hasToken in

            if hasToken {
                self.setup()
            }
            else {
                self.showAuth()
            }
        }
        .addDisposableTo(disposeBag)
    }

    func setup() {

        setupObservables()
        setupProfile()
        setupMap()
        setupLocationManager()
    }

    func setupObservables() {

//        uberAPI.rx_request(.Request, method: .POST, parameters: ["start_place_id": "work"])

        self.uberAPI.rx_request(.RequestCurrent)
        .map {
            return $0["request_id"].stringValue
        }
        .flatMap { requestId -> Observable<JSON> in

//            let requestId = JSON(request)["request_id"].stringValue

            return self.uberAPI.rx_request(.Request, method: .PUT, id: requestId, parameters: ["status": "arriving"])
        }
        .flatMap {_ in
            return self.uberAPI.rx_request(.RequestCurrent)
        }
        .subscribeNext{ current in

            self.driverImageView.layer.cornerRadius = 32
            self.driverImageView.clipsToBounds = true
            self.driverImageView.kf_setImageWithURL(NSURL(string: current["driver"]["picture"].stringValue)!)


        }
        .addDisposableTo(disposeBag)

//        uberAPI.rx_request(.Request, method: .POST, parameters: ["start_place_id": "work"])
//        .subscribeNext { (request) in
//
//            let json = JSON(request)
//            print(json)
//
//            self.uberAPI.rx_request(.Request, method: .PUT, id: json["request_id"].stringValue, parameters: ["status": "arriving"])
//            .subscribeNext { (request) in
//                print(request)
//
//
//                self.uberAPI.rx_request(.RequestCurrent)
//                .subscribeNext { request in
//                    print("Current Status")
//                    print(request)
//
//                    let json = JSON(request)
//
//                    self.driverImageView.layer.cornerRadius = 32
//                    self.driverImageView.clipsToBounds = true
//                    self.driverImageView.kf_setImageWithURL(NSURL(string: json["driver"]["picture_url"].stringValue)!)
//
//                }
//                .addDisposableTo(self.disposeBag)
//            }
//            .addDisposableTo(self.disposeBag)
//        }
//        .addDisposableTo(disposeBag)

//        uberAPI.rx_post("")
//        .subscribeNext { (request) in
//            print(request)
//        }

//        let requestButtonTaps_ = requestButton.rx_tap
//        let currentButtonTaps_ = currentButton.rx_tap
//
//        [requestButtonTaps_, currentButtonTaps_]
//        .toObservable()
//        .merge()
//        .throttle(1, scheduler: MainScheduler.instance)
//        .subscribeNext {
//            print($0)
//            self.meObservable_.subscribeNext{ next in
//                print(next)
//            }
//            .addDisposableTo(self.disposeBag)
//        }
//        .addDisposableTo(disposeBag)


//        let observable = uberAPI.rx_get(.Places(placeId: "home"))
//        let observable = uberAPI.rx_get(
//            .Products(
//                latitude: 37.775818,
//                longitude: -122.418028
//            )
//        )

//        let observable = uberAPI.rx_post("15eaca99-a290-43f1-ad90-237d55434918")

//        func getCurrentRequestId() -> Observable<String> {
//
//            return uberAPI.rx_request(.RequestCurrent)
//            .map { result in
//
//                let json = JSON(result)
//                let requestId = json["request_id"].stringValue
//                print(requestId)
//
//                return requestId
//            }
//        }
//
//        func postRequest(requestId: Observable<String>){
//            requestId.map { requestId in
//                self.uberAPI.rx_post(requestId)
//            }
//            .subscribe { event in
//                print(event)
//            }
//            .addDisposableTo(disposeBag)
//        }

//        getCurrentRequestId()
//        .map {
//            print($0)
//        }
//        .subscribe { event in
////            uberAPI.rx_post(event)
//            print(event)
//        }
//        .addDisposableTo(disposeBag)

    }

    func setupProfile() {
        photoImageView.backgroundColor = UIColor.redColor()
        photoImageView.layer.cornerRadius = 32
        photoImageView.clipsToBounds = true

        uberAPI.rx_request(.Me)
        .subscribeNext { me in
            print(me)
            self.fullName.text = "\(me["first_name"]) \(me["last_name"])"
            self.photoImageView.kf_setImageWithURL(NSURL(string: me["picture"].stringValue)!)

        }
        .addDisposableTo(disposeBag)
    }

    func setupMap() {

        mapView.frame = view.bounds
        mapView.animateToZoom(10)
        view.insertSubview(mapView, atIndex: 0)
    }

    func setupLocationManager() {


            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()

//        print(CLLocationManager.locationServicesEnabled())
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        print(userLocation)
    }

    func showAuth() {

        let authViewController = AuthViewController()
        authViewController.modalPresentationStyle = .OverCurrentContext

        presentViewController(authViewController, animated: true, completion: nil)
    }
}
