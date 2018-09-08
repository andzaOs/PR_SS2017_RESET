//
//  CourseDetailsTableViewController.swift
//  reset-ios
//
//  Created by Andza Os on 03/03/2018.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import UIKit

class CourseDetailsTableViewController: UITableViewController {
    
    var course : Course?
    var uri = String("")
    var hideCellEntryTest = false
    
    @IBOutlet weak var imgEnrolled: UIImageView!
    @IBOutlet weak var imgGit: UIImageView!
    @IBOutlet weak var imgEntryTest: UIImageView!
    @IBOutlet weak var lblEnrolled: UILabel!
    @IBOutlet weak var cellEnrolled: UIView!
    @IBOutlet weak var cellVariant: UIView!
    @IBOutlet weak var cellGit: UIView!
    @IBOutlet weak var cellEntrytest: UIView!
    @IBOutlet var tableViewCourseDetails: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Localized.localize(key: "course_details_title")
        
        setEntrytestEnrollmentValues()
        setEnrolledValues()
        setGitValues()
        
        self.cellEnrolled.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
        self.cellVariant.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
        self.imgEnrolled.image = #imageLiteral(resourceName: "checked-green")
    }
    
    func setEnrolledValues() {
        NetworkManager.sharedInstance.OnWaitingListCourses(controler: self) { onWaitingListCourses, error1 in
            if(onWaitingListCourses != nil) {
                onWaitingListCourses?.forEach { onWaitingListCourse in
                    if(onWaitingListCourse.id == self.course?.id) {
                        self.imgEnrolled.image = #imageLiteral(resourceName: "checked-orange")
                        self.lblEnrolled.text = String.capitalizingFirstLetter(Constants.Status.Waiting)()
                        self.cellEnrolled.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundWaiting)
                        return;
                    }
                }
            }
        }
    }
    
    func setGitValues() {
        CourseDetails.sharedInstance.GetGitRepo(courseId: (self.course?.id)!, controler: self) { uri, error2 in
            if(uri != nil) {
                self.uri = uri!
                self.imgGit.image = #imageLiteral(resourceName: "checked-green")
                self.cellGit.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
            }
        }
    }
    
    func setEntrytestEnrollmentValues() {
        
        EntrytestManager.sharedInstance.GetCourseEnrollment(courseId: (self.course?.id)!, controler: self) {
            enrollment, entrytestEnrollment in
            
            if(enrollment != nil) {
                self.getEntrytestSlots(variantId: (enrollment?.variantId)!)
            }
            
            if(entrytestEnrollment != nil) {
                if(entrytestEnrollment?.testScore != -1) {
                    self.imgEntryTest.image = #imageLiteral(resourceName: "checked-green")
                    self.cellEntrytest.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
                } else {
                    EntrytestManager.sharedInstance.GetSelectedEntrytestSlot(courseId: (self.course?.id)!, controler: self) { selectedSlot, error in
                        if(selectedSlot != nil) {
                            self.cellEntrytest.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundBlue)
                        }
                    }
                }
            }
        }
    }
    
    func getEntrytestSlots(variantId: Int) {
        EntrytestManager.sharedInstance.GetEntryTestSlots(courseId: (course?.id)!, variantId: variantId) { slots, error in
            if(slots == nil) {
                self.hideCellEntryTest = true
                self.tableView.reloadData()
            } else if (error != nil) {
                print("Log: " + String(describing: error))
            }
        }
    }
    
    @IBAction func btnDisenroll(_ sender: Any) {
        NetworkManager.sharedInstance.DeleteCourseEnrollment(courseId: (course?.id)!, controler: self) { success, error in
            if(success)! {
                AlertManager.sharedInstance.alertMessage(message: "delete_enrollment_success", controler: self)
            }
        }
    }
    
    @IBAction func btnModals(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseSettingsTableViewController") as? CourseSettingsTableViewController
        vc?.course = course
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSlots(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestTableViewController") as? EntryTestViewController
        vc?.course = course
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func btnGitRepo(_ sender: Any) {
        if(self.uri != "") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: self.uri)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: self.uri)!)
            }
        } else {
            AlertManager.sharedInstance.alertMessage(message: "git_repo_notfound", controler: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(self.course?.type != "ASE" && section == 1) {
            return "Individual phase"
        } else if(section == 0) {
            return "Enrollment"
        } else if(section == 2) {
            return "Group phase"
        }
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(self.course?.type == "ASE" && section == 1) {
            return 0.00
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.course?.type != "ASE" && section == 1) {
            return 1
        } else if(section == 0 && self.hideCellEntryTest) {
            return 2
        } else if(section == 0 && !self.hideCellEntryTest) {
            return 3
        } else if(section == 2) {
            return 3
        }
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}
