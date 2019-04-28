//
//  HoursTableViewCell.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import UIKit

class HoursTableViewCell: UITableViewCell {
    
    @IBOutlet weak var meetingLocationLabel: UILabel!
    
    var officeHour: OfficeHour! {
        didSet {
            meetingLocationLabel.text = officeHour.title
            //            reviewTextLabel.text = officeHour.text
        }
    }
}
