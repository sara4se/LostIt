//  LocationManager.swift
//  Dalti
//
//  Created by Sara Alhumidi on 28/07/1444 AH.
//

import Foundation
import Combine
import CoreLocation
import FirebaseFirestore
import FirebaseDatabase
import CoreLocation
import GeoFire

class LocationManager: NSObject, CLLocationManagerDelegate,ObservableObject {
    @Published var currentLocation: CLLocation?
    private var locationManager: CLLocationManager?
    let db = Firestore.firestore()
    var userLocation: CLLocation?
    var timer: Timer?
    var userIDs: [String] = []
    //    let ref = Database.database().reference()
  /*  override init() {
        super.init()
        
        locationManager!.delegate = self
        locationManager!.requestAlwaysAuthorization()
        locationManager!.allowsBackgroundLocationUpdates = true
        locationManager!.startUpdatingLocation()
        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [weak self] _ in
            self?.updateUserLocation()
        }
    }*/
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
           self.currentLocation = location
           self.updateLocation(location)
        // Save location to Firestore
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    
    
    // Define function to calculate distance between two locations
    func calculateDistance(_ location1: CLLocation, _ location2: CLLocation) -> CLLocationDistance {
        return location1.distance(from: location2)
    }
    func saveLocation(_ location: [String : Any]) {
//          let locationData = ["latitude": location.coordinate.latitude,
//                              "longitude": location.coordinate.longitude]
        let idPost = self.db.collection("Post").document().documentID
        Firestore.firestore().collection("Community").document("Posts").collection("Post").document(idPost).setData(location)
        print("saved Location")
      }
//    func updateLocation(_ location: CLLocation) {
//        guard let previousLocation = self.currentLocation else { return }
//        let distance = location.distance(from: previousLocation)
//
//        if distance >= 500 { // Save new location if user has moved more than 500 meters
//            self.saveLocation(location)
//
//        }
//    }
    
    // Define function to check if a user is within 1km of current user
   
    func sendNotification(userID: String) {
        // Code for sending notification
    }
    func updateLocation(_ location: CLLocation) {
        guard let previousLocation = self.currentLocation else { return }
        let distance = location.distance(from: previousLocation)
        
        if distance >= 500 { // Save new location if user has moved more than 500 meters
            updateUserLocation()
            print("updateUser Location ")
        }
    }
    func updateUserLocation() {
        // Save initial location
        
        guard let locationManager = locationManager else {
            let newLocationManager = CLLocationManager()
            newLocationManager.requestAlwaysAuthorization()
            newLocationManager.allowsBackgroundLocationUpdates = true
            newLocationManager.startUpdatingLocation()
            self.locationManager = newLocationManager
            return
        }
       
        // Schedule location updates
        let timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { timer in
            locationManager.requestLocation()
            
            guard let initialLocation = locationManager.location else { return }
            let initialLocationData = ["latitude": initialLocation.coordinate.latitude,
                                       "longitude": initialLocation.coordinate.longitude]
            self.saveLocation(initialLocationData)
        }
        
        // Save location to Firestore
//        func saveLocation(_ location: CLLocation) {
//
//            let locationData = ["latitude": location.coordinate.latitude,
//                                "longitude": location.coordinate.longitude]
//            Firestore.firestore().collection("Community").document("Posts").collection("Post").document(idPost).collection("locationOfPost").document().setData(locationData)
//        }
        
        
        // Update location and save to Firestore
   
        let delegateProxy = CLLocationManagerDelegateProxy(
            didUpdateLocations: { [weak locationManager] locations in
                guard let location = locations.last else { return }
                self.updateLocation(location)
            },
            didFailWithError: { error in
                print("Location manager failed with error: \(error.localizedDescription)")
            }
        )
        
        // Set delegate to delegate proxy
        locationManager.delegate = delegateProxy
        //      Keep reference to locationManager to avoid it being deallocated prematurely
        self.locationManager = locationManager
        
    }
    
    // CLLocationManagerDelegate proxy to simplify delegate methods
    class CLLocationManagerDelegateProxy: NSObject, CLLocationManagerDelegate {
        let didUpdateLocations: ([CLLocation]) -> Void
        let didFailWithError: (Error) -> Void
        
        init(didUpdateLocations: @escaping ([CLLocation]) -> Void, didFailWithError: @escaping (Error) -> Void) {
            self.didUpdateLocations = didUpdateLocations
            self.didFailWithError = didFailWithError
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            didUpdateLocations(locations)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            didFailWithError(error)
        }
    }
}


//
/* func checkNearbyUsers() {
 guard let currentUserLocation = locationManager.location else {
 print("Unable to get current user location")
 return
 }
 
 // Retrieve all users' location data from Firebase database
 ref.child("users").observeSingleEvent(of: .value) { (snapshot) in
 guard let users = snapshot.value as? [String: Any] else { return }
 
 // Iterate through each user's location data
 for user in users {
 guard let userLocation = user.value["location"] as? [String: Any],
 let latitude = userLocation["latitude"] as? CLLocationDegrees,
 let longitude = userLocation["longitude"] as? CLLocationDegrees else { continue }
 
 let userCLLocation = CLLocation(latitude: latitude, longitude: longitude)
 
 // Calculate distance between current user and other user
 let distance = calculateDistance(currentUserLocation, userCLLocation)
 
 // If other user is within 1km, send notification
 if distance <= 1000 {
 // Send notification to user
 // (Code for sending notification will depend on your specific implementation)
 print("User \(user.key) is within 1km of current user")
 }
 }
 }
 }*/
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//
//
//    @Published var currentLocation: CLLocation?
//    @Published var locationStatus: CLAuthorizationStatus?
//
//    private let locationManager = CLLocationManager()
//    private var cancellables = Set<AnyCancellable>()
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//
//        $locationStatus
//            .sink { [weak self] status in
//                guard let self = self else { return }
//                if status == .authorizedAlways || status == .authorizedWhenInUse {
//                    self.locationManager.startUpdatingLocation()
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    @nonobjc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let currentLocation = locations.last else { return }
//        print("Current location: \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
//    }
//
//    @nonobjc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.startUpdatingLocation()
//        case .notDetermined, .restricted, .denied:
//            // Prompt the user to enable location services
//            break
//        default:
//            break
//        }
//    }
//    func stopUpdatingLocation() {
//        locationManager.stopUpdatingLocation()
//    }
//
//
//
//}
///*
////extension LocationManager: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//      //  saveLocationToFirestore(location)
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        locationStatus = status
//    }
//
//}
//*/
