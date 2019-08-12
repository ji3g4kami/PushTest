//
//  AppDelegate.swift
//  PushTest
//
//  Created by udn on 2019/8/8.
//  Copyright © 2019 dengli. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder {

  var window: UIWindow?
  
  

}


extension AppDelegate: UIApplicationDelegate {
  
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
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1)}
    print(token)
  }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound, .badge])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    defer {
      completionHandler()
    }
    
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

