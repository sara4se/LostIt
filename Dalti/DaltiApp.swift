//
//  DaltiApp.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

@main
struct DaltiApp: App {
    
    init(){
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color(.black))]
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
         }

    @AppStorage("isOnboarding") var isOnboarding = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingContainerView()
            }
            else {
             //   Splash()
                my_view()
            }
        }
    }
    func application (_ application : UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken : Data){
        print("deviceToken token :\(deviceToken.map({String(format: "%02.2hhx", $0)}).joined())")
      //  self.vm.chatUser?.TokenDiv = deviceToken.map({String(format: "%02.2hhx", $0)}).joined()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.Message_ID"
   
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
       
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Messaging Delegate
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        return true
    }
    

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              willPresent notification: UNNotification,
//                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
//                              -> Void) {
//    let userInfo = notification.request.content.userInfo
//    
//    // With swizzling disabled you must let Messaging know about the message, for Analytics
//    // Messaging.messaging().appDidReceiveMessage(userInfo)
//    
//    // ...
//    
//    // Print full message.
//    print(userInfo)
//    
//    // Change this to your preferred presentation option
//      completionHandler([[.banner, .sound]])
//  }
    
 
  /*  func getNotificationSettings(_ center: UNUserNotificationCenter,completionHandler: @escaping (UNNotificationSettings) -> Void){
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
            let current = UNUserNotificationCenter.current()
            if settings.alertSetting == .enabled {
                current.getNotificationSettings(completionHandler: { permission in
                    switch permission.authorizationStatus  {
                    case .authorized:
                        print("User granted permission for notification")
                    case .denied , .notDetermined:
                        print("User denied notification permission")
                        current.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                    print("All set!")
                                } else if let error = error {
                                    print(error.localizedDescription)
                                }
                        }

                    case .provisional:
                        // @available(iOS 12.0, *)
                        print("The application is authorized to post non-interruptive user notifications.")
                    case .ephemeral:
                        // @available(iOS 14.0, *)
                        print("The application is temporarily authorized to post notifications. Only available to app clips.")
                    @unknown default:
                        print("Unknow Status")
                    }
                })
             } else {
                // Schedule a notification with a badge and sound.
            }
//
          
         
        }}
  */
  /* func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    // ...
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // Print full message.
    print(userInfo)
      center.getNotificationSettings { settings in
          guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }
          let current = UNUserNotificationCenter.current()
          if settings.alertSetting == .enabled {
              current.getNotificationSettings(completionHandler: { permission in
                  switch permission.authorizationStatus  {
                  case .authorized:
                      print("User granted permission for notification")
                  case .denied , .notDetermined:
                      print("User denied notification permission")
                      current.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                          if success {
                                  print("All set!")
                              } else if let error = error {
                                  print(error.localizedDescription)
                              }
                      }

                  case .provisional:
                      // @available(iOS 12.0, *)
                      print("The application is authorized to post non-interruptive user notifications.")
                  case .ephemeral:
                      // @available(iOS 14.0, *)
                      print("The application is temporarily authorized to post notifications. Only available to app clips.")
                  @unknown default:
                      print("Unknow Status")
                  }
              })
           } else {
              // Schedule a notification with a badge and sound.
          }
//
        
       
      }
    completionHandler()
  }*/
  
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                     -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler(UIBackgroundFetchResult.newData)
  }

    func application (_ application : UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken : Data){
        print("deviceToken token :\(deviceToken.map({String(format: "%02.2hhx", $0)}).joined())")
    }
}


extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
     )
//      let trigger = UNLocationNotificationTrigger(region: v, repeats: false)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  
  
}
