//
//  EnrollTableViewController.swift
//  reset-ios
//
//  Created by Andza Os on 17/04/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import UIKit

class EnrollTableViewController: UITableViewController {

    @IBOutlet var tableViewCourses: UITableView!
    var courses: [Course] = [Course]()
    var sectiones: [String] = [String]()
    var selectedCourse = Course()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.sharedInstance.AllCourses() { courses, error in
            
            if(error == nil) {
                
                self.courses = courses!
                
                Courses.sharedInstance.setCourses(courses: courses!)
                Courses.sharedInstance.setSectionesByCourse()
                
                self.sectiones = Courses.sharedInstance.GetCourseSections()
                
                self.tableViewCourses.reloadData()
                
                
            } else {
                
                print("Logg: " + String(describing: error))
                
            }
            
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sectiones.count

    }
    
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        
        let title = String(self.sectiones[section])
        return title!
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let type = self.sectiones[section]
        let count = Courses.sharedInstance.GetCoursesSizePerType(type: type)
        
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Course Cell", for: indexPath)
        
        let courseLine = Courses.sharedInstance.GetCoursesPerType(type: self.sectiones[indexPath.section])
        let course = courseLine[indexPath.row]
        cell.textLabel?.text = ((course.semester?.lowercased())?.capitalizingFirstLetter())! + " semester"
        cell.detailTextLabel?.text = course.status
        
        if(course.status == "enrolled") {
            
            cell.backgroundColor = UIColor.green
            cell.isUserInteractionEnabled = false
            
        } else if(course.status == "on waiting list") {
            
            cell.backgroundColor = UIColor.yellow
            cell.isUserInteractionEnabled = false
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coursesPerType =  Courses.sharedInstance.getCoursesPerType()
        
        let type = sectiones[indexPath.section]
        
        if let course = coursesPerType[type]?[indexPath.row] {
            selectedCourse = course
        }
    
        self.performSegue(withIdentifier: "courseSettingsView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        
        // Create a new variable to store the instance of AccountTableViewController
        
        if(segue.identifier == "courseSettingsView") {
            
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! CourseSettingsTableViewController
            destinationVC.course = selectedCourse
            
        }
        
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

 

}
