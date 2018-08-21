//
//  CourseSettingsTableViewController.swift
//  reset-ios
//
//  Created by Andza Os on 14/08/2017.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import UIKit
import PromiseKit

class CourseSettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var course : Course?
    var courseEnrollment: CourseEnrollment?
    var variants: [Variant] = []
    var programCodes: [ProgramCode] = []
    var courseVariant = CourseVariant()
    var institutes = [String]()
    var pickerViewProgramCodeHidden = true
    var pickerViewCourseVariantHidden = true
    var pickerViewInstituteHidden = true

    @IBOutlet var tableViewCourse: UITableView!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblProgramCode: UILabel!
    @IBOutlet weak var lblInstitute: UILabel!
    @IBOutlet weak var lblCourseVariant: UILabel!
    
    @IBOutlet weak var pickerViewProgramCode: UIPickerView!
    @IBOutlet weak var pickerViewCourseVariant: UIPickerView!
    @IBOutlet weak var pickerViewInstitute: UIPickerView!
    @IBOutlet weak var btnEnrollment: UIButton!
    

    
    @IBAction func btnEnrollment(_ sender: Any) {
        
        if(lblProgramCode.text == "" || lblInstitute.text == "" || lblCourseVariant.text == "") {
            
            AlertManager.sharedInstance.alertMessage(message: "enrollment_bad_input", controler: self)
            
        } else {
            
            self.courseEnrollment?.preferredInstitute = lblInstitute.text;
            self.courseEnrollment?.programCode = lblProgramCode.text;
            
            NetworkManager.sharedInstance.EnrollCourse(enrollment: courseEnrollment!, courseId: (course?.id)!, controler: self) { success, error in
                
                if(success)! {
                    
                        AlertManager.sharedInstance.alertMessage(message: "enrollment_good_input", controler: self)
                    
                        self.btnEnrollment.isUserInteractionEnabled = false
                    
                        self.btnEnrollment.backgroundColor =  UIColor(rgb: Constants.Colors.BackgroundNotActive)
                    
                        self.btnEnrollment.setTitle("",for: .normal)
                    
                        self.tableViewCourse.allowsSelection = false
                    
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    
                } else {
                    print("Log: " + String(describing: error))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        programCodes = ProgramCodes().getProgramCodes()
        
        setUpVariants()
        
        var semester = "S"
        if(course?.semester?.lowercased() == "winter") {
            semester = "W"
        }
        lblCourse.text = (course?.type)! + " " + semester + String(describing: (course?.year)!)
        lblProgramCode.text = programCodes[0].code
        courseEnrollment = CourseEnrollment()
        
    }
    
    
    func setUpVariants() {
        NetworkManager.sharedInstance.GetVariantsNamePerCourse(courseId: (course?.id)!){ variants, error in
            if(variants != nil) {
                Variants.sharedInstance.setVariants(variants: variants!)
                self.variants = Variants.sharedInstance.getVarianst()
                self.setVariant()
            } else {
                print("Log: " + String(describing: error))
            }
        }
    }
    
    func setVariant() {
        CourseSettingsNetManager.sharedInstance.GetCourseEnrollment(courseId: (self.course?.id)!, controler: self) { enrollment, error in
            var variantId = -1
            if(enrollment != nil) {
                variantId = (enrollment?.variantId)!
            } else if (enrollment == nil && error == nil){
                variantId = self.variants[0].id!
            } else {
                print("Log: " + String(describing: error))
            }
            self.setUp(variantId: variantId)
        }
        
    }
    
    func setUp(variantId: Int) {
        
        NetworkManager.sharedInstance.GetCourseVariantMapping(courseId: (self.course?.id)!, variantId: variantId){ mapping, error in
            
            if(error == nil) {
                self.courseVariant = mapping!
                self.lblCourseVariant.text = Variants.sharedInstance.getVarinatNameById(variantId: variantId)
                self.pickerViewCourseVariant.reloadAllComponents()
                self.courseEnrollment?.variantId = variantId
                self.institutes = self.courseVariant.institutes! as! [String]
                self.lblInstitute.text = self.institutes[0]
                self.pickerViewInstitute.reloadAllComponents()
                self.tableView.reloadData()
                
                if(self.variants.count == 1) {
                    let indexVariant = IndexPath(row: 3, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "Variant Cell", for: indexVariant)
                    cell.isUserInteractionEnabled = false
                }
                
                if(self.institutes.count == 1) {
                    let indexInstitute = IndexPath(row: 5, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "Institute Cell", for: indexInstitute)
                    cell.isUserInteractionEnabled = false
                }
            } else {
                print("Log: " + String(describing: error))
            }
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var index = IndexPath(row: 2, section: 0)
        
        if indexPath.row == 1 && pickerViewProgramCode.isHidden {
            togglePickerViewProgramCode()
        } else if indexPath.row == 3 && pickerViewCourseVariant.isHidden && variants.count > 1 {
            togglePickerViewCourseVariant()
            index = IndexPath(row: 4, section: 0)
        } else if indexPath.row == 5 && pickerViewInstitute.isHidden && institutes.count > 1 {
            togglePickerViewInstitute()
            index = IndexPath(row: 6, section: 0)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.selectRow(at: index, animated: true, scrollPosition: UITableViewScrollPosition.bottom)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 && pickerViewProgramCode.isHidden || indexPath.row == 4 && pickerViewCourseVariant.isHidden ||
            indexPath.row == 6 && pickerViewInstitute.isHidden {
            return 0.0
        } else if indexPath.row == 2 && !pickerViewProgramCode.isHidden || indexPath.row == 4 && !pickerViewCourseVariant.isHidden
        || indexPath.row == 6 && !pickerViewInstitute.isHidden {
            return 110.0
        }
        
        return 45.0
    }
    
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerViewProgramCode {
            
            let programName = programCodes[row].code! + " " + programCodes[row].value!
            
            return programName
            
        } else if pickerView == pickerViewCourseVariant {
            
            return variants[row].name
            
        } else {
            
            return institutes[row]
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewProgramCode {
            
            return programCodes.count
            
        } else if pickerView == pickerViewCourseVariant {
            
            return variants.count
            
        } else {
            
            return institutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerViewProgramCode {
            
            lblProgramCode.text = programCodes[row].code!
            
            togglePickerViewProgramCode()
            
        } else if pickerView == pickerViewCourseVariant {
            
            lblCourseVariant.text = variants[row].name
            courseEnrollment?.variantId = variants[row].id
            
            NetworkManager.sharedInstance.GetCourseVariantMapping(courseId: (course?.id)!, variantId: (variants[row].id)!){ mapping, error in
                
                if(error == nil) {
                    
                    self.courseVariant = mapping!
                    self.institutes = self.courseVariant.institutes! as! [String]
                    self.pickerViewInstitute.reloadAllComponents()
                    self.lblInstitute.text = self.institutes[0]
                    
                    self.tableView.reloadData()
                    
                    let indexInstitute = IndexPath(row: 5, section: 0)
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "Institute Cell", for: indexInstitute)
                    
                    if(self.institutes.count > 1) {
                        
                        cell.isUserInteractionEnabled = true
                        
                    } else {
                        
                        cell.isUserInteractionEnabled = false
                    }
                    
                    
                } else {
                    print("Log: " + String(describing: error))
                }
            }
            togglePickerViewCourseVariant()
            
        } else {
            
            self.lblInstitute.text = institutes[row]
            togglePickerViewInstitute()
        }
        
        self.tableView.reloadData()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as! UILabel?
        if label == nil {
            label = UILabel()
        }
        var data = ""
        
        if pickerView == pickerViewProgramCode {
            
            data = programCodes[row].code! + " " + programCodes[row].value!
            let title = NSAttributedString(string: data, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)])
            label?.attributedText = title
            
        } else if pickerView == pickerViewCourseVariant {
            
            data = variants[row].name!
            let title = NSAttributedString(string: data, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)])
            label?.attributedText = title


        } else {
            
            data = institutes[row]
            let title = NSAttributedString(string: data, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)])
            label?.attributedText = title
            
        }
        
        label?.textAlignment = .center
        return label!
        
    }
    
    
    
    func togglePickerViewProgramCode() {
        
        pickerViewProgramCodeHidden = !pickerViewProgramCodeHidden
        
        if(pickerViewProgramCodeHidden) {
            pickerViewProgramCode.isHidden = true
        } else {
            pickerViewProgramCode.isHidden = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func togglePickerViewCourseVariant() {
        
        pickerViewCourseVariantHidden = !pickerViewCourseVariantHidden
        
        if(pickerViewCourseVariantHidden) {
            pickerViewCourseVariant.isHidden = true
        } else {
            pickerViewCourseVariant.isHidden = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func togglePickerViewInstitute() {
        
        pickerViewInstituteHidden = !pickerViewInstituteHidden
        
        if(pickerViewInstituteHidden) {
            pickerViewInstitute.isHidden = true
        } else {
            pickerViewInstitute.isHidden = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
}
