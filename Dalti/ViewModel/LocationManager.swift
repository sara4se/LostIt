//
//  LocationManager.swift
//  Dalti
//
//  Created by Milah Alfaqeeh  on 15/02/2023.
//

import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
  let location = CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118)  // the center for the circul

  let notificationCenter = UNUserNotificationCenter.current()      // To access the notification contor
  
  lazy var Region = makeRegion()      // circle Notification to add to Trigger to add request to the notifition Center
  
 // @Published var NearLoction = false
  
  lazy var locationManager = LocationManager()
  
  
// to updates the location
  private func LocationManager() -> CLLocationManager {
    
    let manager = CLLocationManager()
    manager.allowsBackgroundLocationUpdates = true
   
    return manager
  }

  

  
  // check the locationAuthorization status
  func validateLocationAuthorizationStatus() {
    
    switch locationManager.authorizationStatus {
    
    case .notDetermined, .denied, .restricted:
     
      print("Location Services Not Authorized")
      locationManager.requestWhenInUseAuthorization()
      requestNotificationAuthorization()

   
    case .authorizedWhenInUse, .authorizedAlways:
     
      print("Location Services Authorized")
      requestNotificationAuthorization()

    default:
      break
    }
  }

  

  //ask permision to send notiftion and get to notifition center to add new request
  private func requestNotificationAuthorization() {
      
    let options: UNAuthorizationOptions = [.sound, .alert]
    
    notificationCenter
      .requestAuthorization(options: options) { [weak self] result, _ in
       
        print("Auth Request result: \(result)")
        if result {
          self?.registerNotification()
        }
      }
  }

    // To add region for the Trigger
    private func makeRegion() -> CLCircularRegion {
     
      let region = CLCircularRegion(
        center: location,
        radius: 2,
        identifier: UUID().uuidString)
     
      region.notifyOnEntry = true
   
      
      return region
    }
    
    
  // To add requst to the notifition center
  private func registerNotification() {
    
   
   
    //creat conent  (what notification disply)
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "Welcome to DAN"
    notificationContent.body = "Post info "
    notificationContent.sound = .default

   
    
    // Creat Trigger  past on the location
    let trigger = UNLocationNotificationTrigger(region: Region, repeats: false)

   
    // Creat requset
    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: notificationContent,
      trigger: trigger)

 
    // To access the notification content
    notificationCenter
      // add the requset
      .add(request) { error in
        if error != nil {
          print("Error: \(String(describing: error))")
        }
      }
  }

  
  override init() {
    super.init()
    
    notificationCenter.delegate = self
  }
}



extension LocationManager: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    
    print("Received Notification")
    //  NearLoction = true
    
    completionHandler()
  }

 
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
      @escaping (UNNotificationPresentationOptions) -> Void
  ) {
   
    print("Received Notification in Foreground")
    //  NearLoction = true
    
    completionHandler(.sound)
  }
}

