//
//  CourseDetailVC.swift
//  swiftCoursFinalProj
//
//  Created by James Steele on 4/27/19.
//  Copyright © 2019 James Steele. All rights reserved.
//

import UIKit

class CourseDetailVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
//    @IBOutlet weak var meetingLocation: UILabel!
//    @IBOutlet weak var agendaField: UITextField!
    
    var course: Course!
    var officeHours = OfficeHours()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if course == nil { // We are adding a new record, fields should be editable
            course = Course()
            
            // editable fields should have a border around them
            nameField.addBorder(width: 0.5, radius: 5.0, color: .black)
//            meetingLocation.addBorder(width: 0.5, radius: 5.0, color: .black)
        } else { // Viewing an existing spot, so editing should be disabled
            // disable text editing
            nameField.isEnabled = false
            nameField.backgroundColor = UIColor.clear
            //            addressField.backgroundColor = UIColor.white
            // "Save" and "Cancel" buttons should be hidden
            saveBarButton.title = ""
            cancelBarButton.title = ""
            // Hide Toolbar so that "Lookup Place" isn't available
            navigationController?.setToolbarHidden(true, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            officeHours.loadData(course: course) {
            self.tableView.reloadData()
            if self.officeHours.officeHourArray.count > 0 {
                let test = self.officeHours.officeHourArray.count
                self.nameField.text = String(test)
            } else {
                self.nameField.text = "-.-"
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        course.name = nameField.text!
        switch segue.identifier ?? "" {
        case "AddOfficeHour" :
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! HoursTableViewController
            destination.course = course
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        case "ShowOfficeHour" :
            let destination = segue.destination as! HoursTableViewController
            destination.course = course
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.officeHour = officeHours.officeHourArray[selectedIndexPath.row]
        default:
            print("*** ERROR: Did not have a segue in SpotDetailViewController prepare(for segue:)")
        }
    }
    
    func disableTextEditing() {
        nameField.backgroundColor = UIColor.clear
        nameField.isEnabled = false
        nameField.noBorder()
//        agendaField.backgroundColor = UIColor.clear
//        agendaField.isEnabled = false
//        agendaField.noBorder()
    }
    
    func saveCancelAlert(title: String, message: String, segueIdentifier: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            self.course.saveData { success in
                self.saveBarButton.title = "Done"
                self.cancelBarButton.title = ""
                self.navigationController?.setToolbarHidden(true, animated: true)
                self.disableTextEditing()
                if segueIdentifier == "AddReview" {
                    self.performSegue(withIdentifier: segueIdentifier, sender: nil)
                } else {
                    //                    self.cameraOrLibraryAlert()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUserInterface() {
        nameField.text = course.name
//        meetingLocation.text = course.officeLocation
    }
    
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        saveBarButton.isEnabled = !(nameField.text == "")
    }
    
    @IBAction func textFieldReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
        course.name = nameField.text!
//        course.officeLocation = meetingLocation.text!
        updateUserInterface()
    }

    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        course.name = nameField.text!
//        course.officeLocation = meetingLocation.text!
        course.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
}



extension CourseDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return officeHours.officeHourArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourCell", for: indexPath) as! HoursTableViewCell
        cell.officeHour = officeHours.officeHourArray[indexPath.row]
        return cell
    }
}
