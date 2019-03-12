

import UIKit
import EventKit
class reminderLoadController: UITableViewController {
    let eventStore : EKEventStore = EKEventStore()
    lazy var reminder : EKReminder = EKReminder(eventStore: eventStore)
    var remindersto : [EKReminder]?
    var calendars: [EKCalendar]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareToLoad()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (remindersto?.count ?? 0)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        cell.textLabel?.text = remindersto?[indexPath.row].title
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlrem = remindersto![indexPath.row].calendarItemIdentifier
        print(urlrem)
        let url = NSURL(string: "mobilenotes://")
        UIApplication.shared.openURL(url! as URL)
    }
    func prepareToLoad(){
        let predict = eventStore.predicateForReminders(in: calendars)
        eventStore.fetchReminders(matching: predict) { (reminders) in
            for remind in reminders! {
                print("yes")
               print(remind.title)
                
            
        }
            
    print(reminders?.count ?? 0)
            self .remindersto = reminders
    }
   
}
}
