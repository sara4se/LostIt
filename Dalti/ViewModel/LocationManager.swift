//
//  LocationManager.swift
//  Dalti
//
//  Created by Milah Alfaqeeh  on 15/02/2023.
//

import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
  // the center for the circul
  let location = CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118)
  // To access the notification contor
  let notificationCenter = UNUserNotificationCenter.current()
  // circle Notification to add to Trigger to add request to the notifition Center
  lazy var Region = makeRegion()
  
  @Published var didArriveAtTakeout = false
  // 1
  lazy var locationManager = makeLocationManager()
  // 2
  
// to updates the location
  private func makeLocationManager() -> CLLocationManager {
    // 3
    let manager = CLLocationManager()
    manager.allowsBackgroundLocationUpdates = true
    // 4
    return manager
  }

  // 1
  // to add the circul for the Trigger
  private func makeRegion() -> CLCircularRegion {
    // 2
    let region = CLCircularRegion(
      center: location,
      radius: 2,
      identifier: UUID().uuidString)
    // 3
    region.notifyOnEntry = true
    // 4
    return region
  }

  // 1
  
  // check the locationAuthorization status
  func validateLocationAuthorizationStatus() {
    // 2
    switch locationManager.authorizationStatus {
    // 3
    case .notDetermined, .denied, .restricted:
      // 4
      print("Location Services Not Authorized")
      locationManager.requestWhenInUseAuthorization()
      requestNotificationAuthorization()

    // 5
    case .authorizedWhenInUse, .authorizedAlways:
      // 6
      print("Location Services Authorized")
      requestNotificationAuthorization()

    default:
      break
    }
  }

  // 1
  //ask permision to send notiftion and get to notifition center to add new request
  private func requestNotificationAuthorization() {
    // 2
    let options: UNAuthorizationOptions = [.sound, .alert]
    // 3
    notificationCenter
      .requestAuthorization(options: options) { [weak self] result, _ in
        // 4
        print("Auth Request result: \(result)")
        if result {
          self?.registerNotification()
        }
      }
  }

  // 1
  // to add requst to the notifition center
  private func registerNotification() {
    // 2
    // To access the notification content
   
    //creat conent  (what notification disply)
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "Welcome to Swifty TakeOut"
    notificationContent.body = "Your order will be ready shortly."
    notificationContent.sound = .default

    // 3
    
    // Creat Trigger  past on the location
    let trigger = UNLocationNotificationTrigger(region: Region, repeats: false)

    // 4
    // Creat requset
    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: notificationContent,
      trigger: trigger)

    // 5
    // add the requset
    notificationCenter
      .add(request) { error in
        if error != nil {
          print("Error: \(String(describing: error))")
        }
      }
  }

  // 1
  override init() {
    super.init()
    // 2
    notificationCenter.delegate = self
  }
}
extension LocationManager: UNUserNotificationCenterDelegate {
  // 1
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // 2
    print("Received Notification")
    didArriveAtTakeout = true
    // 3
    completionHandler()
  }

  // 4
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
      @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // 5
    print("Received Notification in Foreground")
    didArriveAtTakeout = true
    // 6
    completionHandler(.sound)
  }
}

