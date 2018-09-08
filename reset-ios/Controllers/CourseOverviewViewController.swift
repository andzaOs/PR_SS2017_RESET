//
//  EnrollTableViewController.swift
//  reset-ios
//
//  Created by Andza Os on 17/04/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import UIKit

class CourseOverviewViewController: UITableViewController {

    @IBOutlet var tableViewCourses: UITableView!
    var courses: [Course] = [Course]()
    var sectiones: [String] = [String]()
    var selectedCourse = Course()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Localized.localize(key: "course_overview_title")
        NetworkManager.sharedInstance.AllCourses(controler: self) { courses, error in
            
            self.courses = courses!
            
            Courses.sharedInstance.setCourses(courses: courses!)
            Courses.sharedInstance.setTypeSections()
            
            self.sectiones = Courses.sharedInstance.getTypeSections()
            
            self.tableViewCourses.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectiones.count

    }
    
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        let title = String(self.sectiones[section])
        return title
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = self.sectiones[section]
        let count = Courses.sharedInstance.getCoursesPerType(type: type).count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Course Cell", for: indexPath)
        
        let coursesPerType = Courses.sharedInstance.getCoursesPerType(type: self.sectiones[indexPath.section])
        let course = coursesPerType[indexPath.row]
        
        let enrollmentEnd = course.endEnrollment;
        let now = Date()
        
        cell.textLabel?.text = ((course.semester?.lowercased())?.capitalizingFirstLetter())! + " semester"
        
        cell.detailTextLabel?.text = course.status
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.Fonts.Title))
        
        if(course.status! == Constants.Status.NotEnrolled && (enrollmentEnd as Date?)! > now) {
            
            cell.isUserInteractionEnabled = true
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            if let enrollmentLimit = course.enrollmentLimit as Int?,
                let enrolledUsers = course._enrolledUsers as Int? {
                
                if(enrollmentLimit == enrolledUsers) {
                    cell.detailTextLabel?.text = Constants.Labels.Wait
                }
            } else {
                cell.detailTextLabel?.text = Constants.Labels.Enroll
            }

            
        } else {
            cell.isUserInteractionEnabled = false
            if(course.status == Constants.Status.NotEnrolled) {
                cell.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundNotActive)
                cell.detailTextLabel?.text = Constants.Status.NotActive
                cell.detailTextLabel?.textColor = UIColor(rgb: Constants.Colors.DetailNotActive)
                cell.textLabel?.textColor = UIColor(rgb: Constants.Colors.TitleNotActive)
                cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.Fonts.Detail))
                
            } else if(course.status == Constants.Status.Enrolled) {
                
                cell.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundEnrolled)
                cell.detailTextLabel?.textColor = UIColor(rgb: Constants.Colors.DetailEnrolled)
                cell.textLabel?.textColor = UIColor(rgb: Constants.Colors.TitleEnrolled)
                cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.Fonts.Detail))
                
            } else if(course.status == Constants.Status.Waiting) {
                
                cell.backgroundColor = UIColor(rgb: Constants.Colors.BackgroundWaiting)
                cell.detailTextLabel?.textColor = UIColor(rgb: Constants.Colors.DetailWaiting)
                cell.textLabel?.textColor = UIColor(rgb: Constants.Colors.TitleWaiting)
                cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.Fonts.Detail))
                
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coursesPerType =  Courses.sharedInstance.getCoursesPerType()
        let type = sectiones[indexPath.section]
        if let course = coursesPerType[type]?[indexPath.row] {
            selectedCourse = course
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseSettingsTableViewController") as? CourseSettingsTableViewController
        vc?.course = selectedCourse
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
