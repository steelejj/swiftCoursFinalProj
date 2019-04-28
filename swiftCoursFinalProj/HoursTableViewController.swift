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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberAttendingLabel: UILabel!
    @IBOutlet weak var meetingLocationLabel: UILabel!
    @IBOutlet weak var agendaLabel: UILabel!
    @IBOutlet weak var agendaView: UITextView!
    @IBOutlet weak var signUpPressed: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    var course: Course!
    var officeHour: OfficeHour!
    let dateFormatter = DateFormatter()
    var test = "test"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard (course) != nil else {
            print("*** ERROR: did not have a valid Spot in ReviewDetailViewController.")
            return
        }
        if officeHour == nil {
            officeHour = OfficeHour()
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameLabel.text = course.name
        meetingLocationLabel.text = course.officeLocation
        enableDisableSaveButton()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        if officeHour.documentID == "" { // This is a new review
            addBordersToEditableObjects()
        } else {
            if officeHour.postingUserID == Auth.auth().currentUser?.email { // This review was posted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                deleteButton.isHidden = false
            } else { // This review was posted by another user
                cancelBarButton.title = ""
                saveBarButton.title = ""
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
        officeHour.name = agendaLabel.text!
        officeHour.professorName = agendaView.text!
        officeHour.saveData(course: course) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func reviewTitleChanged(_ sender: UITextField) {
        enableDisableSaveButton()
    }
    
    @IBAction func returnTitleDonePressed(_ sender: UITextField) {
        saveThenSegue()
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
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveThenSegue()
    }
    
}
