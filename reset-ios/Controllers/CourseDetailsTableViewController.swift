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
    
    @IBOutlet weak var imgEnrolled: UIImageView!
    @IBOutlet weak var lblEnrolled: UILabel!
    @IBOutlet var tableViewCourseDetails: UITableView!
    @IBOutlet weak var cellEnrolled: UIView!
    @IBOutlet weak var cellVariant: UIView!
    
    @IBAction func btnDisenroll(_ sender: Any) {
        NetworkManager.sharedInstance.DeleteCourseEnrollment(courseId: (course?.id)!, controler: self) { success, error in
            
            if(success)! {
                AlertManager.sharedInstance.alertMessage(message: "delete_enrollment_success", controler: self)
            } else {
                print("Log: " + String(describing: error))
            }
        }
    }

    @IBAction func btnModals(_ sender: Any) {
        self.performSegue(withIdentifier: "detailsSettingsView", sender: self)
    }
    
    @IBAction func btnSlots(_ sender: Any) {
        self.performSegue(withIdentifier: "entrytestView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if(segue.identifier == "detailsSettingsView") {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! CourseSettingsTableViewController
            destinationVC.course = course
        } else if(segue.identifier == "entrytestView") {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! EntrytestTableViewController
            destinationVC.course = course
        }
    }
    
    
    override func viewDidLoad() {
        
        NetworkManager.sharedInstance.OnWaitingListCourses(controler: self) { onWaitingListCourses, error in
            
            if(onWaitingListCourses != nil) {
                onWaitingListCourses?.forEach { onWaitingListCourse in
                    if(onWaitingListCourse.id == self.course?.id) {
                        self.imgEnrolled.image = #imageLiteral(resourceName: "checked-orange")
                        self.lblEnrolled.text = String.capitalizingFirstLetter(Constants.Status.Waiting)()
                        self.cellEnrolled.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundWaiting)
                        return;
                    }
                }
            } else {
                print("Log: " + String(describing: error))
            }
        }
        
        self.cellEnrolled.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
        self.cellVariant.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
        self.imgEnrolled.image = #imageLiteral(resourceName: "checked-green")
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
}
