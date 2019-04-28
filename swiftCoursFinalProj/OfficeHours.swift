//
//  OfficeHours.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import Foundation
import Firebase

class OfficeHours {
    var officeHourArray: [OfficeHour] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(course: Course, completed: @escaping () -> ())  {
        guard course.documentID != "" else {
            return
        }
        db.collection("courses").document(course.documentID).collection("hours").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.officeHourArray = []
            // there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let officeHour = OfficeHour(dictionary: document.data())
                officeHour.documentID = document.documentID
                self.officeHourArray.append(officeHour)
            }
            completed()
        }
    }
}

