//
//  DashboardTableViewController.swift
//  reset-ios
//
//  Created by Andza Os on 13/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController{

    
    @IBOutlet var tableViewCourses: UITableView!
    var courses: [Course] = [Course]()
    var selectedCourse = Course()
    var user = User()
    var sections: [Int] = [Int]()
    
    private var mocCourses: [Course] = [Course.init(type: "Test",
                                                    year: 2018,
                                                    semester: "IV",
                                                    enrollmentLimit: 1,
                                                    startEnrollment: NSDate(),
                                                    endEnrollment: NSDate(),
                                                    archived: true,
                                                    links: NSArray(), id: 1)!]
    
    @IBAction func btnSettings(_ sender: Any){
         //self.performSegue(withIdentifier: "settingsView", sender: self)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountTableViewController") as? AccountTableViewController
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    @IBAction func btnEnroll(_ sender: Any) {
        //self.performSegue(withIdentifier: "enrollView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkManager.sharedInstance.GetAccount(controler: self) { user, error in
            if(error != nil) {
                print("Log: " + String(describing: error))
                
            } else {
                
                if(user != nil) {
                    self.user = user!
                }
                
                NetworkManager.sharedInstance.CoursesPerUser(controler: self) { courses, error in
                    
                    if(error == nil) {
                        
                        self.courses = courses!
                        
                        Courses.sharedInstance.setCourses(courses: courses!)
                        Courses.sharedInstance.setYearSections()
                        
                        self.sections = Courses.sharedInstance.getYearSections()
                        
                        self.tableViewCourses.reloadData()
                        
                    } else {
                        print("Log: " + String(describing: error))
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        let title = String(self.sections[section])
        return title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let year = self.sections[section]
        let count = Courses.sharedInstance.getCoursesPerYear(year: year).count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Course Cell", for: indexPath)
        let coursesPerYer = Courses.sharedInstance.getCoursesPerYear(year: self.sections[indexPath.section])
        let course = coursesPerYer[indexPath.row]
        cell.textLabel?.text = course.type
        cell.detailTextLabel?.text = ((course.semester?.lowercased())?.capitalizingFirstLetter())! + " semester"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coursesPerYear =  Courses.sharedInstance.getCoursesPerYear()
        let year = sections[indexPath.section]
        if let course = coursesPerYear[Int(year)]?[indexPath.row] {
            selectedCourse = course
        }
        //self.performSegue(withIdentifier: "courseDetailsView", sender: self)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsTableViewController") as? CourseDetailsTableViewController
        vc?.course = selectedCourse
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        /*let nav = segue.destination as! UINavigationController
        if(segue.identifier == "settingsView") {
            let destinationVC = nav.topViewController as! AccountTableViewController
            destinationVC.user = user
        } else if(segue.identifier == "courseDetailsView") {
            let destinationVC = nav.topViewController as! CourseDetailsTableViewController
            destinationVC.course = selectedCourse
        }*/
    }
    
}
