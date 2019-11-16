//
//  LocationService.swift
//  TooHealthy
//
//  Created by Artem Belkov on 16.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import CoreLocation

final class LocationService: NSObject {
    typealias Success = ((CLLocation) -> Void)
    typealias Fail = ((Error) -> Void)
    
    private let manager = CLLocationManager()

    private var success: Success?
    private var fail: Fail?

    func get(success: Success? = nil, fail: Fail? = nil) {
        self.success = success
        self.fail = fail
        
        manager.delegate = self
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        success?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fail?(error)
    }
}
