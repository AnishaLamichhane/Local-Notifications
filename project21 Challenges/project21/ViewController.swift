//
//  ViewController.swift
//  project21
//
//  Created by Anisha Lamichhane on 9/4/20.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
var is24Hours = false
    
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
        var timeInterval:Int = 0
        if is24Hours {
            timeInterval = 86400
        } else {
            timeInterval = 5
        }
        
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
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "Show", title: "Tell me more...", options: .foreground)
        let remind = UNNotificationAction(identifier: "Remind", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("custom data received \(customData)")
            
            switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
//                 the user swiped to unlock
                    showAlert(title: "\(response.actionIdentifier)", message: "Default identifier")
                    print("defaultIdentifier")
                
                case "show":
                    is24Hours = false
                    showAlert(title: "Show more information", message: "Show")
                 print("Show more information")
                    
            case "later":
                is24Hours = true
                showAlert( title: "Remind Me Later", message: "The same alert is shown in 24 hours")
                sheduleLocal()
                print("remind me later")
            default:
                break;
            }
        }
        
        completionHandler()
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true)
    }
}

