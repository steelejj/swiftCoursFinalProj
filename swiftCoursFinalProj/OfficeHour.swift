//
//  OfficeHour.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import Foundation
import Firebase

class OfficeHour: NSObject {

    
    var name: String
    var professorName: String
    var date: String
    var time: String
    var meetingLocation: String
    var agenda: String
    var roster: [String]
    var postingUserID: String
    var courseDocumentID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "professorName": professorName, "date": date, "time": time, "meetingLocation": meetingLocation, "roster":  roster, "agenda": agenda, "postingUserID": postingUserID, "courseDocumentID": courseDocumentID]
    }
    
    init(name: String, professorName: String, date: String, time: String, meetingLocation: String, roster: [String], agenda: String, postingUserID: String, courseDocumentID: String, documentID: String) {
                self.name = name
                self.professorName = professorName
                self.date = date
                self.time = time
                self.meetingLocation = meetingLocation
                self.roster = roster
                self.agenda = agenda
                self.postingUserID = postingUserID
                self.courseDocumentID = courseDocumentID
                self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
                let name = dictionary["name"] as! String? ?? ""
                let professorName = dictionary["professorName"] as! String? ?? ""
                let date = dictionary["date"] as! String? ?? ""
                let time = dictionary["time"] as! String? ?? ""
                let meetingLocation = dictionary["meetingLocation"] as! String? ?? ""
                let roster = dictionary["roster"] as! [String]? ?? [""]
                let agenda = dictionary["agenda"] as! String? ?? ""
                let postingUserID = dictionary["postingUserID"] as! String? ?? ""
                let courseDocumentID = dictionary["courseDocumentID"] as! String? ?? ""
                self.init(name: name, professorName: professorName, date: date, time: time, meetingLocation: meetingLocation, roster: roster, agenda: agenda, postingUserID: postingUserID, courseDocumentID: courseDocumentID, documentID: "")
    }
    
    convenience override init() {
                let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
                self.init(name: "", professorName: "", date: "", time: "", meetingLocation: "", roster: [""], agenda: "", postingUserID: currentUserID, courseDocumentID: "", documentID: "")
    }
    
    

    func saveData(course: Course, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        
        // Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        // if we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("courses").document(course.documentID).collection("hours").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) in course \(course.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    course.updateHour {
                        completed(true)
                    }
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("courses").document(course.documentID).collection("hours").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document in course \(course.documentID) for new review documentID \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    course.updateHour {
                        completed(true)
                    }
                }
            }
        }
    }
    
    func deleteData(course: Course, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("courses").document(course.documentID).collection("hours").document(documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: deleting review documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
                course.updateHour {
                    completed(true)
                }
            }
        }
    }
    
}

