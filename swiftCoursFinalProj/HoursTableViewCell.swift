//
//  HoursTableViewCell.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import UIKit

class HoursTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var meetingLocationLabel: UILabel!
    
    var officeHour: OfficeHour! {
        didSet {
            dateLabel.text = officeHour.date
            timeLabel.text = officeHour.time
            meetingLocationLabel.text = officeHour.meetingLocation
            
            //            reviewTextLabel.text = officeHour.text
        }
    }
}
