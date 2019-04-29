//
//  HoursTableViewController.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import UIKit
import Firebase

class HoursTableViewController: UITableViewController {
    
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var postedByLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var timeLabel: UITextField!
    @IBOutlet weak var numberAttendingLabel: UILabel!
    @IBOutlet weak var meetingLocationLabel: UITextField!
    @IBOutlet weak var agendaLabel: UILabel!
    @IBOutlet weak var agendaView: UITextView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    var course: Course!
    var officeHour: OfficeHour!
    let user = Auth.auth().currentUser!.email ?? ""

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard (course) != nil else {
            print("*** ERROR: did not have a valid Course.")
            return
        }
        
        if course == nil {
            course = Course()
        }
        
        if officeHour == nil {
            officeHour = OfficeHour()
        }

        
        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameLabel.text = course.name
        postedByLabel.text = course.professorName
        meetingLocationLabel.text = course.officeLocation
        dateLabel.text = officeHour.date
        timeLabel.text = officeHour.time
        numberAttendingLabel.text = String(officeHour.roster.count)
        agendaView.text = officeHour.agenda
        
        
        enableDisableSaveButton()
        if officeHour.documentID == "" { // This is a new hour
            addBordersToEditableObjects()
        } else {
            if officeHour.postingUserID == Auth.auth().currentUser?.email { // This review was posted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                deleteButton.isHidden = false
                signUpButton.isHidden = true
            } else { // This review was posted by another user
                cancelBarButton.title = "Back"
                saveBarButton.title = ""
                deleteButton.isHidden = true
            }
        }
    }
    
    func addBordersToEditableObjects() {
        agendaLabel.addBorder(width: 0.5, radius: 5.0, color: .black)
        agendaView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func enableDisableSaveButton() {
        if agendaLabel.text != "" {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    func saveThenSegue() {
        officeHour.name = nameLabel.text!
        officeHour.professorName = postedByLabel.text!
        officeHour.meetingLocation = meetingLocationLabel.text!
        officeHour.date = dateLabel.text!
        officeHour.time = timeLabel.text!
        officeHour.agenda = agendaView.text!
        officeHour.saveData(course: course) { (success) in
            print(success)
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    func leaveViewController() {
        print("leaving vc")
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        officeHour.deleteData(course: course) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("😡 ERROR: Delete unsuccessful")
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if officeHour.roster.contains(user) {
            if let index = officeHour.roster.index(of:user) {
                officeHour.roster.remove(at: index)
            }
        } else {
            officeHour.roster.append(user)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveThenSegue()
    }
    
}
