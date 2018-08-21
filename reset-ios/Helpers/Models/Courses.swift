//
//  Courses.swift
//  reset-ios
//
//  Created by Andza Os on 14/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation


class Courses {
    
    static let sharedInstance = Courses()
    
    var courses = [Course]()
    var yearSections = [Int]()
    var typeSections = [String]()
    var coursesPerType: [String: [Course]] = [String: [Course]]()
    var coursesPerYear: [Int: [Course]] = [Int: [Course]]()
    
    func setCourses(courses: [Course]) {
        self.courses = courses
    }
    
    func getCourses() -> [Course] {
        return courses
    }
    
    func getCoursesPerType() -> [String: [Course]] {
        return coursesPerType
    }
    
    func getCoursesPerYear() -> [Int: [Course]] {
        return coursesPerYear
    }
    
    func setYearSections() {
        var sections = [Int]()
        
        for course in self.courses {
            
            if !sections.contains(course.year!) {
                
                sections.append(course.year!)
                
                coursesPerYear[course.year!] = [course]
                
            } else {
                coursesPerYear[course.year!]?.append(course)
            }
        }
        self.yearSections = sections.sorted { $0 > $1 }
    }
    
    func getYearSections() -> [Int] {
        return yearSections
    }
    
    func setTypeSections() {
        
        var sections = [String]()
        
        for course in self.courses {
            
            if !sections.contains(course.type!) {
                
                sections.append(course.type!)
                
                coursesPerType[course.type!] = [course]
                
            } else {
                coursesPerType[course.type!]?.append(course)
            }
        }
        self.typeSections = sections.sorted(by: <)
    }
    
    func getTypeSections() -> [String] {
        return typeSections
    }
    
    func getCoursesPerYear(year:Int) -> [Course] {
        
        var coursesPerYear = [Course]()
        
        for course in self.courses{
            
            if course.year == year {
                
                coursesPerYear.append(course)
        
            }
        }
        return coursesPerYear
    }
    
    func getCoursesPerType(type: String) -> [Course] {
        
        var coursesPerType = [Course]()
        
        for course in self.courses{
            
            if course.type == type {
                
                coursesPerType.append(course)
            }
        }
        return coursesPerType
    }
}
