//
//  Courses.swift
//  reset-ios
//
//  Created by Andza Os on 14/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation


class Courses{
    
    static let sharedInstance = Courses()
    
    var courses = [Course]()
    var sectionesByYear = [Int]()
    var sectionesByCourse = [String]()
    var coursesPerType: [String: [Course]] = [String: [Course]]()
    
    func setCourses(courses: [Course]) {
        self.courses = courses
    }
    
    func getCourses() -> [Course] {
        return courses
    }
    
    func getCoursesPerType() -> [String: [Course]] {
        return coursesPerType
    }
    
    func setSectionesByYear() {
        self.sectionesByYear = GetYearSections()
        self.sectionesByYear = self.sectionesByYear.sorted { $0 > $1 }
    }
    
    func getSectionesByYear() -> [Int] {
        return sectionesByYear
    }
    
    func setSectionesByCourse() {
        self.sectionesByCourse = GetCourseSections()
    }
    
    func getSectionesByCourse() -> [String] {
        return sectionesByCourse
    }
    
    func GetYearSections() -> [Int] {
        
        var sections = [Int]()
        
        for course in self.courses {
            
            if sections.contains(course.year!) == false {
                
                sections.append(course.year!)
                
            }
            
        }
        
        return sections
        
    }
    
    func GetCourseSections() -> [String] {
        
        var sections = [String]()
        
        for course in self.courses {
                        
            if !sections.contains(course.type!) {
                
                sections.append(course.type!)
                
                coursesPerType[course.type!] = [course]

            } else {
                 coursesPerType[course.type!]?.append(course)
            }
            
        }
        return sections
        
    }
    
    func GetCoursesSizePerYear(year:Int) -> Int {
        
        var count = 0
        
        for course in self.courses {
            
            if course.year == year {
                
                count += 1
                
            }
            
        }
        
        return count
        
    }
    
    func GetCoursesSizePerType(type: String) -> Int {
        
        var count = 0
        
        for course in self.courses {
            
            if course.type == type {
                
                count += 1
                
            }
            
        }
        
        return count
        
    }
    
    func GetCoursesPerYear(year:Int) -> [Course] {
        
        var coursesPerYear = [Course]()
        
        for course in self.courses{
            
            if course.year == year {
                
                coursesPerYear.append(course)
                
            }
            
        }
        
        return coursesPerYear
    }
    
    func GetCoursesPerType(type: String) -> [Course] {
        
        var coursesPerType = [Course]()
        
        for course in self.courses{
            
            if course.type == type {
                
                coursesPerType.append(course)
                
            }
            
        }
        
        return coursesPerType
    }


}
