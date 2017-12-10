//
//  LocatonManager.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/8/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import CoreLocation

protocol ILocationService {
    func locate(completion: @escaping (CLLocation?) -> Void)
}

class LocationService: NSObject, CLLocationManagerDelegate, ILocationService {
    
    let locationManager = CLLocationManager()
    
    private var permissionHandler: ((Bool) -> Void)?
    private var locationHandlers = [((CLLocation?) -> Void)]()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
    }
    
    // MARK: - ILocationService
    
    func locate(completion: @escaping (CLLocation?) -> Void) {
        requestPermissionIfNeeded { [weak self] (isGaranteed) in
            if isGaranteed {
                self?.locationHandlers.append(completion)
                self?.locationManager.requestLocation()
            } else {
                completion(nil)
            }
        }
    }
    
    private func requestPermissionIfNeeded(completion:@escaping (_ isGarnteed: Bool) -> Void) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            permissionHandler = completion
        }
    }
    
    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationHandlers.forEach({ $0(locations.first) })
        locationHandlers.removeAll()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationHandlers.forEach({ $0(nil) })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined { return }
        let isAllow = status == .authorizedWhenInUse
        permissionHandler?(isAllow)
        permissionHandler = nil
    }
}
