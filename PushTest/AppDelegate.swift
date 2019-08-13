//
//  AppDelegate.swift
//  PushTest
//
//  Created by udn on 2019/8/8.
//  Copyright © 2019 dengli. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder {

  var window: UIWindow?
  let gcmMessageIDKey = "gcm.message_id"

}


extension AppDelegate: UIApplicationDelegate, MessagingDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // `requestAuthorization` runs off the main queue
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.badge, .sound, .alert]) {
      [weak self] granted, _ in
      guard granted else { return }
      
      center.delegate = self
      
      DispatchQueue.main.async {
        application.registerForRemoteNotifications()
      }
    }
    
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    return true
  }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
    
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  
  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    print("Message Data:", remoteMessage.appData)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1)}
    print(token)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    guard let imageUrl = userInfo["imageUrl"] as? String,
    let url = URL(string: imageUrl) else {
      completionHandler(.noData)
      return
    }
    if let rootVC = window?.rootViewController?.children.first as? ViewController {
      rootVC.chaneCustomImage(imageUrl: url)
      completionHandler(.newData)
    }
  }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
    let userInfo = notification.request.content.userInfo
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    // Change this to your preferred presentation option
    completionHandler([.alert, .sound, .badge])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    defer {
      completionHandler()
    }
    
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let rootVC: ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    let rootNav = UINavigationController(rootViewController: rootVC)
    rootNav.navigationBar.prefersLargeTitles = true
    window?.rootViewController = rootNav

    guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
    let payload = response.notification.request.content

    if let storyboardID = payload.userInfo["storyboardID"] as? String{
      if storyboardID == "present" {
        rootVC.presentPressed("")
      } else if storyboardID == "navigation" {
        rootVC.performSegue(withIdentifier: "toNavigation", sender: nil)
      }
    }
  }
}

