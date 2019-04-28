//
//  BHUser.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import Foundation
import Firebase

class BHUser {
    var email: String
    var displayName: String
    var photoURL: String
    var userSince: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["email": email, "displayName": displayName, "photoURL": photoURL, "userSince": userSince, "documentID": documentID ]
    }
    
    init(email: String, displayName: String, photoURL: String, userSince: Date, documentID: String) {
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.userSince = userSince
        self.documentID = documentID
    }
    
    convenience init(user: User) {
        self.init(email: user.email ?? "", displayName: user.displayName ?? "", photoURL: (user.photoURL != nil ? "\(user.photoURL!)" : ""), userSince: Date(), documentID: user.uid)
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let displayName = dictionary["displayName"] as! String? ?? ""
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        let userSince = dictionary["userSince"] as! Date? ?? Date()
        self.init(email: email, displayName: displayName, photoURL: photoURL, userSince: userSince, documentID: "")
    }
    
    func saveIfNewUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("😡 ERROR: could not access document for user \(userRef.documentID)")
                return
            }
            guard document?.exists == false else {
                print("^^^ The document for user \(self.documentID) already exists. No reason to create it")
                return
            }
            self.saveData()
        }
    }
    
    func saveData() {
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        db.collection("users").document(documentID).setData(dataToSave) { error in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription), could not save data for \(self.documentID)")
            }
        }
    }
}
