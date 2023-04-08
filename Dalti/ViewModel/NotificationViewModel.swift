//
//  NotificationViewModel.swift
//  Dalti
//
//  Created by Sara Alhumidi on 26/08/1444 AH.
//
 
import Foundation
import Firebase
import FirebaseFirestore
import CoreLocation
import UserNotifications

class NotificationViewModel: NSObject, UNUserNotificationCenterDelegate {
    
    var notificationCenter: UNUserNotificationCenter
    var db = Firestore.firestore()
    override init() {
        self.notificationCenter = UNUserNotificationCenter.current()
        super.init()
        self.notificationCenter.delegate = self
    }
    
    func retrieveLocations(completion: @escaping ([CLLocation]) -> Void) {
        let idPost = self.db.collection("Post").document().documentID
        let locationRef = Firestore.firestore()
            .collection("Community")
            .document("Posts")
            .collection("Post")
            .document(idPost)
            .collection("LocationPost")
        
        locationRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving locations from Firebase: \(error.localizedDescription)")
                completion([])
            } else {
                var locations: [CLLocation] = []
                for document in snapshot?.documents ?? [] {
                    guard let latitude = document.data()["latitude"] as? CLLocationDegrees,
                          let longitude = document.data()["longitude"] as? CLLocationDegrees else {
                        continue
                    }
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    locations.append(location)
                }
                completion(locations)
            }
        }
    }
    
    func sendNotificationIfNeeded(to locations: [CLLocation], from userLocation: CLLocation) {
        let center = userLocation.coordinate
        for location in locations {
            let distance = location.distance(from: userLocation)
            if distance <= 1000 {
                let content = UNMutableNotificationContent()
                content.title = "Nearest location"
                content.subtitle = "You are near a location within 1 km"
                content.sound = UNNotificationSound.default
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error adding notification request: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    func showAlert(title: String, message: String) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = message
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error adding notification request: \(error.localizedDescription)")
                }
            }
        }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
}
