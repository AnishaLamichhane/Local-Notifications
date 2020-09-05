//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Anisha Lamichhane on 6/12/20.
//  Copyright © 2020 Anisha Lamichhane. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var askedQuestion = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "SCORE", style: .plain, target: self, action: #selector(showScore))
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
        content.title = "Guess The Flag"
        content.body = "Enjoy the new quiz everyday."
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
        
        let show = UNNotificationAction(identifier: "Show", title: "Play the game", options: .foreground)
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
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        title = " tap on \(countries[correctAnswer].uppercased())'s flag "
    }
    func startNewGame(action: UIAlertAction!) {
        score = 0
        askedQuestion = 0
        askQuestion()
    }
    func close(action: UIAlertAction!) {
        return
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title:String = ""
        for i in 0...2 {
            if sender.tag == correctAnswer {
                title = "Correct!"
                score += 1
                break
            }
            else {
                if i != correctAnswer && sender.tag == i {
                     title = "wrong ! this is \(countries[i])"
                     score -= 1
                    
                }
            }
        }
            if askedQuestion < 10 {
                let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
                askedQuestion += 1
            }
            else {
                let finalAlertController = UIAlertController(title: title, message: "Your final score is \(score).", preferredStyle: .alert)
                finalAlertController.addAction(UIAlertAction(title: "Start a new game", style: .default, handler: startNewGame))
                               present(finalAlertController, animated: true)
            }
            
        }
    @objc func showScore() {
        let scoreAlert = UIAlertController(title: "SCORE", message: "Your final score is \(score).", preferredStyle: .alert)
                       scoreAlert.addAction(UIAlertAction(title: "CLOSE", style: .default, handler: close))
                                      present(scoreAlert, animated: true)
     }
    }
    


