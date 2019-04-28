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
    @IBOutlet weak var meetingLocation: UILabel!
    @IBOutlet weak var agendaField: UITextField!
    
    var course: Course!
    var officeHours: OfficeHours!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if course == nil { // We are adding a new record, fields should be editable
            course = Course()
            
            // editable fields should have a border around them
            nameField.addBorder(width: 0.5, radius: 5.0, color: .black)
            meetingLocation.addBorder(width: 0.5, radius: 5.0, color: .black)
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
                let hour = self.officeHours.officeHourArray
                self.meetingLocation.text = "test"
            } else {
                self.meetingLocation.text = "-.-"
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
        agendaField.backgroundColor = UIColor.clear
        agendaField.isEnabled = false
        agendaField.noBorder()
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
        meetingLocation.text = course.officeLocation
    }
    
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //    func cameraOrLibraryAlert() {
    //        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    //        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
    //            self.accessCamera()
    //        }
    //        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
    //            self.accessLibrary()
    //        }
    //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    //        alertController.addAction(cameraAction)
    //        alertController.addAction(photoLibraryAction)
    //        alertController.addAction(cancelAction)
    //        present(alertController, animated: true, completion: nil)
    //    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        saveBarButton.isEnabled = !(nameField.text == "")
    }
    
    @IBAction func textFieldReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
        course.name = nameField.text!
        course.officeLocation = meetingLocation.text!
        updateUserInterface()
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        if course.documentID == "" {
            saveCancelAlert(title: "This Venue Has Not Been Saved", message: "You must save theis venue before you can add a photo.", segueIdentifier: "AddPhoto")
        } else {
            //            cameraOrLibraryAlert()
        }
    }
    
    //    @IBAction func reviewButtonPressed(_ sender: UIButton) {
    //        if spot.documentID == "" {
    //            saveCancelAlert(title: "This Venue Has Not Been Saved", message: "You must save theis venue before you can review it.", segueIdentifier: "AddReview")
    //        } else {
    //            performSegue(withIdentifier: "AddReview", sender: nil)
    //        }
    //    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        course.name = nameField.text!
        course.officeLocation = meetingLocation.text!
        course.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    //    @IBAction func lookupPlacePressed(_ sender: UIBarButtonItem) {
    //        let autocompleteController = GMSAutocompleteViewController()
    //        autocompleteController.delegate = self
    //        present(autocompleteController, animated: true, completion: nil)
    //    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
}

//extension SpotDetailViewController: GMSAutocompleteViewControllerDelegate {
//
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        spot.name = place.name
//        spot.address = place.formattedAddress ?? ""
//        spot.coordinate = place.coordinate
//        dismiss(animated: true, completion: nil)
//        updateUserInterface()
//    }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//}



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

//extension CourseDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photos.photoArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! SpotPhotosCollectionViewCell
//        cell.photo = photos.photoArray[indexPath.row]
//        return cell
//    }
//}

//extension SpotDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        let photo = Photo()
//        photo.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//
//        dismiss(animated: true) {
//            photo.saveData(spot: self.spot) { (success) in
//            }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func accessLibrary() {
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
//    }
//
//    func accessCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//            present(imagePicker, animated: true, completion: nil)
//        } else {
//            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
//        }
//    }
//}

