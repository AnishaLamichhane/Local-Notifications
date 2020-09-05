//
//  ViewController.swift
//  project21
//
//  Created by Anisha Lamichhane on 9/4/20.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shedule", style: .plain, target: self, action: #selector(sheduleLocal))
        
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]){ granted, error in
            if granted{
                print("Yay")
            } else {
                print("Oops")
            }
            
        }
    }
    
    @objc func sheduleLocal()  {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late WakeUp Call"
        content.body = "This notification is part of the project 21 hope it works and shows."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["CustomData" : "fizzBuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "Show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("custom data received \(customData)")
            
            switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
//                 the user swiped to unlock
                    print("defaultIdentifier")
                
                case "show":
                 print("Show more information")
                
            default:
                break;
            }
        }
        
        completionHandler()
    }
}

