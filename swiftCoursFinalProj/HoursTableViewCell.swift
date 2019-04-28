//
//  HoursTableViewCell.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import UIKit

class HoursTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet var starImageCollection: [UIImageView]!
    
    var officeHour: OfficeHour! {
        didSet {
            reviewTitleLabel.text = officeHour.title
            //            reviewTextLabel.text = officeHour.text
        }
    }
}
