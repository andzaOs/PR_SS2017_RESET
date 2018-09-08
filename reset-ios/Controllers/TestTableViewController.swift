//
//  TestTableViewController.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 26.08.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import UIKit
import Alamofire

class EntryTestViewController: UITableViewController {

    var course : Course?
    var enrollment: CourseEnrollment?
    var entrytestSlots: [EntrytestSlot] = [EntrytestSlot]()
    var sections = [String]()
    var slotId: Int = -1
    
    @IBOutlet var tableViewSlots: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        EntrytestNetManager.sharedInstance.GetCourseEnrollment(courseId: (self.course?.id)!, controler: self) {
            enrollment, id in
            if(enrollment != nil && id != nil) {
                self.slotId = id!
                self.getSlotsPerCourse(variantId: (enrollment?.variantId)!)
            }
        }
    }
    
    func getSlotsPerCourse(variantId: Int) {
        EntrytestNetManager.sharedInstance.GetEntryTestSlots(courseId: (course?.id)!, variantId: variantId) { slots, error in
            if(slots != nil) {
                self.entrytestSlots = slots!
                EntrytestSlots.sharedInstance.setSlots(entrytestSlots: self.entrytestSlots)
                self.sections = EntrytestSlots.sharedInstance.getSections()
                self.tableView.reloadData()
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
        return EntrytestSlots.sharedInstance.getSections().count
    }
    
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        if(self.sections.count == 0) {
            return ""
        }
        let title = String(self.sections[section])
        return title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.sections.count == 0) {
            return 0
        } else if(self.sections[section] == Constants.ChoosenSlot) {
            return 1
        }
        
        return EntrytestSlots.sharedInstance.getSlotsPerDate(date: self.sections[section]).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Slot Cell", for: indexPath)
        var slot = EntrytestSlot()
        
        if(self.sections[indexPath.section] == Constants.ChoosenSlot) {
            
            if(slotId != -1) {
                slot = EntrytestSlots.sharedInstance.getSlotById(slotId: slotId)
                cell.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
            }
        } else {
            
            var slotPerDate = EntrytestSlots.sharedInstance.getSlotsPerDate(date: self.sections[indexPath.section])
            slot = slotPerDate[indexPath.row]
            if(slot.id == self.slotId) {
                 cell.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
            }
        }
        
        cell.textLabel?.text = slot.location
        return cell
    }

}
