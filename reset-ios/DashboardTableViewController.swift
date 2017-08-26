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
    var user = User()
    var sectiones: [Int] = [Int]()
    
    @IBAction func btnSettings(_ sender: Any){
        
         self.performSegue(withIdentifier: "settingsView", sender: self)
        
    }
    
    @IBAction func btnEnroll(_ sender: Any) {
    
        self.performSegue(withIdentifier: "enrollView", sender: self)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        NetworkManager.sharedInstance.GetAccount() { user, error in
            if(error != nil) {
                
                print("Log: " + String(describing: error))
                
            } else {
                
                if(user != nil) {
                    
                    self.user = user!
                    
                }
                
                NetworkManager.sharedInstance.CoursesPerUser() { courses, error in
                    
                    if(error == nil) {
                        
                        self.courses = courses!
                        
                        Courses.sharedInstance.setCourses(courses: courses!)
                        Courses.sharedInstance.setSectionesByYear()
                        
                        self.sectiones = Courses.sharedInstance.getSectionesByYear()
                        
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
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sectiones.count
    
    }
    
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        
        let title = String(self.sectiones[section])
        return title
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let year = self.sectiones[section]
        let count = Courses.sharedInstance.GetCoursesSizePerYear(year: year)
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Course Cell", for: indexPath)

        let courseLine = Courses.sharedInstance.GetCoursesPerYear(year: self.sectiones[indexPath.section])
        let course = courseLine[indexPath.row]
        cell.textLabel?.text = course.type
        cell.detailTextLabel?.text = ((course.semester?.lowercased())?.capitalizingFirstLetter())! + " semester"
        

        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {

        
        // Create a new variable to store the instance of AccountTableViewController
        
        if(segue.identifier == "settingsView") {
            
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! AccountTableViewController
            destinationVC.user = user
        }
    }


}
