//
//  UserTableViewCell.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/28/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import UIKit
import SDWebImage

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userSinceLabel: UILabel!
    
    var bHUser: BHUser! {
        didSet {
            
            photoImage.layer.cornerRadius = photoImage.frame.size.width / 2
            photoImage.clipsToBounds = true
            
            displayNameLabel.text = bHUser.displayName
            emailLabel.text = bHUser.email
            let formattedDate = dateFormatter.string(from: bHUser.userSince)
            userSinceLabel.text = "\(formattedDate)"
            
            guard let url = URL(string: bHUser.photoURL) else {
                photoImage.image = UIImage(named: "singleUser")
                print("😡 ERROR: Could not convert photoURL named \(bHUser.photoURL) into a valid URL")
                return
            }
            photoImage.sd_setImage(with: url, placeholderImage: UIImage(named: "singleUser"))
        }
    }
}
