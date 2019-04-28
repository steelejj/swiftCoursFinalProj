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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var date: String!
    //    date = ""
    var course: Course! {
        didSet {
            nameLabel.text = course.name
            
            // calculate distance here
            guard let date = date else {
                return
            }
            //            let distanceInMeters = currentLocation.distance(from: spot.location)
            //            let distanceString = "Distance: \( (distanceInMeters * 0.00062137).roundTo(places: 2) ) miles"
            //            distanceLabel.text = distanceString
            //            ratingLabel.text = "Avg. Rating: \(spot.averageRating.roundTo(places: 1))"
        }
    }
}
