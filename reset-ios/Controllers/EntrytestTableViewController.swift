//
//  EntrytestTableViewController.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 26.07.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import UIKit

class EntrytestTableViewController: UITableViewController {
    
    var course : Course?
    var enrollment: CourseEnrollment?
    var entrytestSlots: [EntrytestSlot] = [EntrytestSlot]()
    var sections = [String]()
    var slotId: Int = -1
    var setted = false
    
    @IBOutlet var tableViewSlots: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUp()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSlots.reloadData()
    }
    
    func getSlotId() {
        EntrytestNetManager.sharedInstance.GetEntryTestSlotId(courseId: (course?.id)!, controler: self) { entrytestSlotId, error in

            if(entrytestSlotId != nil) {
                self.slotId = entrytestSlotId!
            } else if (error != nil) {
                 print("Log: " + String(describing: error))
            }
        }
    }
    
    func getSlotsPerCourse(variantId: Int) {
        EntrytestNetManager.sharedInstance.GetEntryTestSlots(courseId: (course?.id)!, variantId: variantId) { slots, error in
    
            if(slots != nil) {
                self.entrytestSlots = slots!
                EntrytestSlots.sharedInstance.setSlots(entrytestSlots: self.entrytestSlots)
                self.sections = EntrytestSlots.sharedInstance.getSections()
                self.tableViewSlots.reloadData()
            } else if (error != nil) {
                print("Log: " + String(describing: error))
            }
        }
    }
    
    func setUp() {
        CourseSettingsNetManager.sharedInstance.GetCourseEnrollment(courseId: (course?.id)!, controler: self) { enrollment, error in
            
            if(enrollment != nil) {
                self.getSlotId()
                self.getSlotsPerCourse(variantId: (enrollment?.variantId)!)
                self.setted = true
            } else if (error != nil) {
                print("Log: " + String(describing: error))
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        print(EntrytestSlots.sharedInstance.getSections().count)
        return EntrytestSlots.sharedInstance.getSections().count
    }
    
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        let title = String(self.sections[section])
        return title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(self.sections[section] == Constants.ChoosenSlot)
        {
            return 1
        }
        let count = EntrytestSlots.sharedInstance.getSlotsPerDate(date: self.sections[section]).count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Slot Cell", for: indexPath)
        var slot = EntrytestSlot()
        
        if(self.sections[indexPath.section] == Constants.ChoosenSlot) {
            
            if(slotId != -1) {
                slot = EntrytestSlots.sharedInstance.getSlotById(slotId: slotId)
            }
        } else {
            
            var slotPerDate = EntrytestSlots.sharedInstance.getSlotsPerDate(date: self.sections[indexPath.section])
            slot = slotPerDate[indexPath.row]
        }
        
        cell.textLabel?.text = slot.location
        return cell
    }
    
}
