//
//  LocationViewModel.swift
//  Dalti
//
//  Created by Sara Alhumidi on 26/08/1444 AH.
//

import Foundation
import CoreLocation
import Combine
import FirebaseFirestore
import Firebase

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private let updateInterval: TimeInterval = 600 // 10 minutes
    private var firestoreTimer: Timer?
    let notificationViewModel = NotificationViewModel()
    @Published var userLocation: CLLocation?

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        startUpdatingLocation()
        startUpdatingLocationIfNeeded()
        startFirestoreTimer()
    }

    private func startUpdatingLocationIfNeeded() {
        if let location = userLocation, abs(location.timestamp.timeIntervalSinceNow) > updateInterval {
            startUpdatingLocation()
        }
    }

    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if userLocation == nil {
            print("Got initial user location: \(location)")
        }

        userLocation = location
        stopUpdatingLocation()
        print("i stopUpdatingLocation location")
        DispatchQueue.main.asyncAfter(deadline: .now() + updateInterval) {
            self.startUpdatingLocationIfNeeded()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }

    var coordinateString: String {
        guard let coordinate = userLocation?.coordinate else {
            return "Unknown"
        }
        let latString = String(format: "%.6f", coordinate.latitude)
        let lonString = String(format: "%.6f", coordinate.longitude)
        return "\(latString), \(lonString)"
    }

    private func startFirestoreTimer() {
        firestoreTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true, block: { _ in
            self.saveUserLocationToFirestore()
        })
    }

    private func saveUserLocationToFirestore() {
        guard let userLocation = userLocation else { return }

        let idPost = "nE7ABn2of06cyT2GSIwM" // Replace with the actual post ID

        let firestore = Firestore.firestore()
        let locationCollection = firestore.collection("Community").document("Posts").collection("Post").document(idPost).collection("LocationPost")

        let locationData: [String: Any] = [
            "latitude": userLocation.coordinate.latitude,
            "longitude": userLocation.coordinate.longitude,
            "timestamp": Timestamp(date: userLocation.timestamp)
        ]

        locationCollection.addDocument(data: locationData) { error in
            if let error = error {
                print("Failed to save location to Firestore: \(error)")
            } else {
                print("Saved location to Firestore: \(userLocation)")
            }
        }
        
    }
    func showAlert(title: String, message: String) {
         let content = UNMutableNotificationContent()
         content.title = title
         content.subtitle = message
         content.sound = UNNotificationSound.default
         
         let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        notificationViewModel.notificationCenter.add(request) { error in
             if let error = error {
                 print("Error adding notification request: \(error.localizedDescription)")
             }
         }
     }
    func checkNearbyLocations() {
        guard let userLocation = userLocation else { return }
        let idPost = "nE7ABn2of06cyT2GSIwM" // Replace with the actual post ID
        let firestore = Firestore.firestore()
        let locationCollection = firestore.collection("Community").document("Posts").collection("Post").document(idPost).collection("LocationPost")
    
        locationCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting nearby locations: \(error.localizedDescription)")
                return
            }
            
            guard let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents {
                guard let latitude = document.data()["latitude"] as? Double,
                      let longitude = document.data()["longitude"] as? Double else { continue }
                
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let distance = userLocation.distance(from: location)
                
                if distance <= 1000 {
                    // Show alert in the view
                    self.notificationViewModel.showAlert(title: "Nearby Location", message: "You are within 1km of a location.")
                    break
                }
            }
        }
    }

    deinit {
        firestoreTimer?.invalidate()
    }
}

