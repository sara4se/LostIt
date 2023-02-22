 //  LocationManager.swift
//  Dalti
//
//  Created by Sara Alhumidi on 28/07/1444 AH.
//

import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
    // 24.793550,46.746728
    @Published var locationCurrent = CLLocationCoordinate2D()
    let notificationCenter = UNUserNotificationCenter.current()
    lazy var storeRegion = makeStoreRegion()
    @Published var didArriveAtTakeout = false
    static let geoCoder = CLGeocoder()
    lazy var locationManager = makeLocationManager()
    
//
//    func locationCurrnent() -> CLLocationCoordinate2D{
//       // let lc = locationManager.location
//     //   locationCurrent = CLLocationCoordinate2D(latitude: lc?.coordinate.latitude ?? 0.0, longitude: lc?.coordinate.longitude ?? 0.0)
//
//        return locationCurrent
//    }
  
    private func makeLocationManager() -> CLLocationManager {
        // 3
        let manager = CLLocationManager()
      
        manager.allowsBackgroundLocationUpdates = true
        manager.startMonitoringVisits()
        // 4
        return manager
    }
    
    // 1
    private func makeStoreRegion() -> CLCircularRegion {
        // 2
        let region = CLCircularRegion(
            center: locationCurrent,
            radius: 32,
            identifier: UUID().uuidString)
        // 3
        region.notifyOnEntry = true
//        region.notifyOnExit
        // 4
        return region
    }
    
    // 1
    
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
    private func requestNotificationAuthorization() {
        // 2
        let options: UNAuthorizationOptions = [.sound, .alert]
        // 3
        notificationCenter
            .requestAuthorization(options: options) { [weak self] result, _ in
                // 4
                print("Auth Request result: \(result)")
                if result {
                self!.registerNotification()
                }
            }
    }
    
    // 1
   private func registerNotification(){
        // 2
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.sound = UNNotificationSound.default
        
        // 3
      //  let trigger = UNLocationNotificationTrigger(region: storeRegion, repeats: false)
        // show this notification five seconds from now
       
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
        
        //let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // 4
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        // 5
        notificationCenter
            .add(request) { error in
                if error != nil {
                    print("Error this is me : \(String(describing: error))")
                }
            }
        
        // add our notification request
       if (locationCurrent.longitude == locationCurrent.longitude || locationCurrent.latitude == locationCurrent.latitude){
            UNUserNotificationCenter.current().add(request)
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
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
extension LocationManager: CLLocationManagerDelegate {
    
    func newVisitReceived(_ visit: CLVisit, description: String) {
      let location = Location(visit: visit, descriptionString: description)
        locationCurrent.latitude = location.latitude
        locationCurrent.latitude = location.longitude
      let content = UNMutableNotificationContent()
      content.title = "New Journal entry 📌"
      content.body = location.description
      content.sound = UNNotificationSound.default
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
      let request = UNNotificationRequest(identifier: location.dateString, content: content, trigger: trigger)
      
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // create CLLocation from the coordinates of CLVisit
        let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        
        // Get location description
        LocationManager.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
                let description = "\(place)"
                self.newVisitReceived(visit, description: description)
            }
        }
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//      guard let location = locations.first else {
//        return
//      }
//        LocationManager.geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
//        if let place = placemarks?.first {
//          let description = "Fake visit: \(place)"
//
//          let fakeVisit = FakeVisit(coordinates: location.coordinate, arrivalDate: Date(), departureDate: Date())
//          self.newVisitReceived(fakeVisit, description: description)
//        }
//      }
//    }
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
        completionHandler([[.banner, .sound]])
    }
    
}
