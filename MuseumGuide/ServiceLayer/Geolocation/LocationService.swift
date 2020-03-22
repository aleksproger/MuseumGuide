//
//  LocationService.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

protocol Geolocation: class, Loggable {
    func determineCoordinates() -> Future<LocationState.Event, LocationError>?
}

public class LocationService: NSObject, Geolocation {
    private let locationManager = CLLocationManager()
    private let locationPublisher: PassthroughSubject<CLLocation, LocationError>
    public var defaultLoggingTag: LogTag { .service }
    private var subscriptions = Set<AnyCancellable>()

    
    override init() {
        self.locationPublisher = PassthroughSubject<CLLocation, LocationError>()
        super.init()
        setup()
    }
    
    //MARK: - Methods
    
    func determineCoordinates() -> Future<LocationState.Event, LocationError>? {
        Future<LocationState.Event, LocationError> { [unowned self] promise in
            guard CLLocationManager.locationServicesEnabled() else {
                self.log(.debug, "Location services not enabled")
                return promise(.failure(.locationServicesNotEnabled))
                
            }
            self.locationPublisher
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        return promise(.failure(error))
                    }
                }, receiveValue:{ location in
                    return promise(.success(.fetched(location: location)))
                })
                .store(in: &self.subscriptions)
            self.locationManager.requestLocation()
            self.log(.debug, "Requested location")
        }
    }
    
    private func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
    }
}

//MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else {
            log(.debug, "Can't get location")
            locationPublisher.send(completion: .failure(.noLocation))
            return
        }
        locationPublisher.send(userLocation)
        log(.debug, "Got location \(userLocation)")
        manager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        log(.debug, error.localizedDescription)
        locationPublisher.send(completion: .failure(.other(error.localizedDescription)))
    }
}
