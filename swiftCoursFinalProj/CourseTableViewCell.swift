//
//  CourseTableViewCell.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professorNameLabel: UILabel!
    
    var date: String!
    //    date = ""
    var course: Course! {
        didSet {
            nameLabel.text = course.name
            professorNameLabel.text = course.professorName
        }
    }
}
