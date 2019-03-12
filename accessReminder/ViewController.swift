//
//  ViewController.swift
//  accessReminder
//
//  Created by phoebe on 3/11/19.
//  Copyright © 2019 phoebe. All rights reserved.
//

import UIKit
import EventKit
class ViewController: UIViewController {
    let eventStore : EKEventStore = EKEventStore()
    lazy var reminder : EKReminder = EKReminder(eventStore: eventStore)
    var remindersto : [EKReminder]?
    var calendars: [EKCalendar]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
  
    }

    @IBAction func addReminder(_ sender: Any) {
        eventStore.requestAccess(to: EKEntityType.reminder) { (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                let reminder:EKReminder = EKReminder(eventStore: self.eventStore)
                reminder.title = "Must do this!"
                reminder.priority = 2
                reminder.notes = "...this is a note"
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                let DateTime = formatter.date(from: "2019/03/15 05:00");
             //   let alarmTime = Date().addingTimeInterval(3*60)
                let alarm = EKAlarm(absoluteDate: DateTime!)
                reminder.addAlarm(alarm)
                
                reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
                
                do {
                    try self.eventStore.save(reminder, commit: true)
                    
                } catch {
                    let alert = UIAlertController(title: "Reminder could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                print("Reminder saved")
            }
        }
    }
    
    @IBAction func removeReminder(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let DateTime = formatter.date(from: "2019/03/15 05:00");
        let component = DateComponents(year: 2019, month: 3, day: 15, hour: 05, minute: 00)
        let predict = eventStore.predicateForReminders(in: calendars)
        let text = "must do this"
        eventStore.fetchReminders(matching: predict) { (reminders) in
            for remind in reminders! {
                if remind.title.lowercased().contains(text.lowercased()){
                    do{
                        try self.eventStore.remove(remind, commit: true)
                        print("yes")
                    }catch{
                        let alert = UIAlertController(title: "Reminder could not find", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(OKAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }else{
                    print("no")
                }
            }
        }
       
       /* for i in remindersto! {
            if i.completionDate == DateTime{
                print("done")
            }
        }*/
    }
    func deleteEntry(reminder : EKReminder){
        do{
            try eventStore.remove(reminder, commit: false)
        }catch{
            print("Error while deleting Reminder: \(error.localizedDescription)")
        }
    }
}


