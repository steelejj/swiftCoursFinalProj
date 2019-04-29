//
//  Course.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import Foundation
import Firebase

class Course: NSObject {
    
    var name: String
    var professorName: String
    var officeLocation: String
    var roster: [String]
    var postingUserID: String
    var password: String
    var documentID: String
    
    var title: String? {
        return name
    }
    var subtitle: String? {
        return professorName
    }
    var dictionary: [String: Any] {
        return ["name": name, "professorName": professorName, "officeLocation": officeLocation, "roster":  roster, "password": password, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(name: String, professorName: String, officeLocation: String, roster: [String], password: String, postingUserID: String, documentID: String) {
        self.name = name
        self.professorName = professorName
        self.officeLocation = officeLocation
        self.roster = roster
        self.password = password
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience override init() {
        self.init(name: "", professorName: "", officeLocation: "", roster: [""], password: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let professorName = dictionary["professorName"] as! String? ?? ""
        let officeLocation = dictionary["officeLocation"] as! String? ?? ""
        let roster = dictionary["roster"] as! [String]? ?? [""]
        let password = dictionary["password"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        self.init(name: name, professorName: professorName, officeLocation: officeLocation, roster: roster, password: password, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("Error: could not save data because we dont have a valid postinuserid")
            return completion(false)
        }
        self.postingUserID = postingUserID
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("courses").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("error updating document \(self.documentID) \(error.localizedDescription)")
                    return completion(false)
                } else {
                    completion(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("courses").addDocument(data: dataToSave) {error in
                if let error = error {
                    print("error updating document \(ref?.documentID) \(error.localizedDescription)")
                    return completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func updateHour(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let hoursRef = db.collection("courses").document(self.documentID).collection("hours")
        hoursRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: failed to get query snapshot of reviews for hoursRef: \(hoursRef.path), error: \(error!.localizedDescription)")
                return completed()
            }
            //            var ratingTotal = 0.0
            //            for document in querySnapshot!.documents { // go through all of the reviews documents
            //                let courseDictionary = document.data()
            //                let rating = courseDictionary["rating"] as! Int? ?? 0
            //                ratingTotal = ratingTotal + Double(rating)
            //            }
            ////            self.averageRating = ratingTotal / Double(querySnapshot!.count)
            ////            self.numberOfReviews = querySnapshot!.count
            //            let dataToSave = self.dictionary
            //            let spotRef = db.collection("courses").document(self.documentID)
            //            spotRef.setData(dataToSave) { error in // save it & check errors
            //                guard error == nil else {
            //                    print("*** ERROR: updating document \(self.documentID) in spot after changing averageReview & numberOfReviews, error: \(error!.localizedDescription)")
            //                    return completed()
            //                }
            //                print("^^^ Document updated with ref ID \(self.documentID)")
            //                completed()
            //            }
        }
    }
    
}

