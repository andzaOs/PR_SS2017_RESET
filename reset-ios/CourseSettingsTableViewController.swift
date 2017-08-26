//
//  CourseSettingsTableViewController.swift
//  reset-ios
//
//  Created by Andza Os on 14/08/2017.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import UIKit

class CourseSettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var course : Course?
    var variants: [String] = []
    var programCodes: [String] = []

    @IBOutlet var tableViewCourse: UITableView!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblProgramCode: UILabel!
    @IBOutlet weak var pickerViewProgramCode: UIPickerView!
    @IBOutlet weak var lblCourseVariant: UILabel!
    @IBOutlet weak var pickerViewCourseVariant: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        programCodes = ProgramCodes().getProgramCodes()
        
        NetworkManager.sharedInstance.GetVariantsNamePerCourse(courseId: (course?.id)!){ variants, error in
            
            if(error == nil) {
                
                Variants.sharedInstance.setVariants(variants: variants!)
                
                self.variants = Variants.sharedInstance.getVarianst()
                
                print("Log1: " + String(describing: self.variants.count))
                
            } else {
                
                print("Log: " + String(describing: error))
                
            }
            
        }
        
        lblCourse.text = (course?.type)! + " " + String(describing: (course?.semester)!) + " " + String(describing: (course?.year)!)
        lblProgramCode.text = programCodes[0]
        lblCourseVariant.text = ""
        
        self.tableViewCourse.reloadData()
        pickerViewCourseVariant.delegate = self
        self.pickerViewCourseVariant.reloadAllComponents()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func btnBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        print("Log: " + String(describing: variants.count))
        
        if pickerView == pickerViewProgramCode {
            
            return programCodes[row]
            
        } else {
            
            return variants[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewProgramCode {
            
            return programCodes.count
            
        } else {
            
            return variants.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerViewProgramCode {
            
            lblProgramCode.text = programCodes[row]
            
        } else {
            
            lblCourseVariant.text = variants[row]
        }

        
        
    }
}
