//
//  EntryTestViewController.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 30.08.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import UIKit
import Alamofire

class EntryTestViewController: UITableViewController {

    var course : Course?
    var enrollment: CourseEnrollment?
    var entrytestSlots: [EntrytestSlot] = [EntrytestSlot]()
    var sections = [String]()
    var entrytest = Entrytest()
    var entrytestEnrollment = EntrytestEnrollment()
    
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet var tableViewSlots: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = Localized.localize(key: "entrytestslots_title")
        EntrytestManager.sharedInstance.GetCourseEnrollment(courseId: (self.course?.id)!, controler: self) {
            enrollment, entrytestEnrollment in
            
            if(enrollment != nil && entrytestEnrollment != nil) {
                self.entrytestEnrollment = entrytestEnrollment!
                self.getSlotsPerCourse(variantId: (enrollment?.variantId)!)
                self.enrollment = enrollment
            }
        }
    }
    
    func getSlotsPerCourse(variantId: Int) {
        EntrytestManager.sharedInstance.GetEntryTestSlots(courseId: (course?.id)!, variantId: variantId) { slots, error in
            if(slots != nil) {
                self.entrytestSlots = slots!
                EntrytestSlots.sharedInstance.setSlots(entrytestSlots: self.entrytestSlots)
                self.getEntryTest(entrytestId: slots![0].entryTestId!)
                self.sections = EntrytestSlots.sharedInstance.getSections()
            } else if (error != nil) {
                print("Log: " + String(describing: error))
            }
        }
    }
    
    func getEntryTest(entrytestId: Int) {
        
        EntrytestManager.sharedInstance.GetEntrytest(entrytestId: entrytestId) { entrytest, error in
            if(entrytest != nil) {
                self.entrytest = entrytest!
                self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Slot Cell", for: indexPath) as! EntryTestTableViewCell
        
        
        var slot = EntrytestSlot()
        
        if(self.sections[indexPath.section] == Constants.ChoosenSlot) {
            
            if(self.entrytestEnrollment.entryTestSlotId != nil) {
                slot = EntrytestSlots.sharedInstance.getSlotById(slotId: self.entrytestEnrollment.entryTestSlotId!)
                cell.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
                cell.lblDateTime.text = EntrytestSlots.sharedInstance.getChoosenSlotDetails(slot: slot)
                cell.lblCapacity.isHidden = true
                cell.lblDateTime.textColor = UIColor(rgb: Constants.Colors.DetailEnrolled)
                cell.lblLocation.textColor = UIColor(rgb: Constants.Colors.DetailEnrolled)
            }
            
        } else {

            var slotPerDate = EntrytestSlots.sharedInstance.getSlotsPerDate(date: self.sections[indexPath.section])
            slot = slotPerDate[indexPath.row]
            if(slot.id == self.entrytestEnrollment.entryTestSlotId) {
                cell.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
                cell.lblDateTime.textColor = UIColor(rgb: Constants.Colors.DetailEnrolled)
                cell.lblCapacity.textColor = UIColor(rgb: Constants.Colors.DetailEnrolled)
                cell.lblLocation.textColor = UIColor(rgb: Constants.Colors.DetailEnrolled)
                
            } else {
                cell.imgChecked.isHidden = true
            }
            cell.lblDateTime.text = EntrytestSlots.sharedInstance.getSlotDetails(slot: slot)
            cell.lblCapacity.text = String(slot.currentAttendees!) + "/" + String(slot.maxAttendees!)
        }
        
        cell.lblLocation.text = slot.location
        cell.lblLocation.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.Fonts.Detail))
        
        if(self.entrytest.endEnrollment != nil) {
            if((self.entrytest.endEnrollment as Date?)! < Date()) {
                cell.btnDisenroll.isHidden = true
                lblNote.text = Localized.localize(key: "entrytestslots_note")
                lblNote.textColor = UIColor.red
            }
        }
        
        if(self.entrytest.maxScore != -1) {
            cell.btnDisenroll.isHidden = true
        }
        
        if(self.entrytest.entryTestSlots.count == 0) {
            if((self.entrytest.startEnrollment as Date?)! > Date()) {
                lblNote.text = Localized.localize(key: "entrytestslots_no_slots")
                lblNote.textColor = UIColor.red
            }
        }
        
        return cell
    }
}
