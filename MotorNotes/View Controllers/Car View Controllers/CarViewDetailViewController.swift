//
//  EditCarViewController.swift
//  MotorNotes
//
//  Created by Neri Garcia on 4/13/20.
//  Copyright © 2020 Jonathon Chenvert. All rights reserved.
//

import UIKit
import Firebase

class CarViewDetailViewController: UIViewController {
    
    // Car information labels
    @IBOutlet weak var carNicknameLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carMakeLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carYearLabel: UILabel!
    @IBOutlet weak var carOdometerLabel: UILabel!
    @IBOutlet weak var carLicensePlateLabel: UILabel!
    @IBOutlet weak var carVinLabel: UILabel!
    @IBOutlet weak var carRegistrationDateLabel: UILabel!
    @IBOutlet weak var carColorLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var seeServiceRecordsButton: UIButton!
    @IBOutlet weak var seeFuelRecordsButton: UIButton!
    @IBOutlet weak var addServiceButton: UIButton!
    @IBOutlet weak var addFuelButton: UIButton!
    
    var carID: String = "" // Selected car from HomeVC
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllerDesigns()

        // Firestore db setup
        db = Firestore.firestore()
                
        loadCarData()
    }
    
    // MARK: - View Controller design aspects
    func viewControllerDesigns() {
        
        // Button designs
        Utilities.styleFilledButton(seeServiceRecordsButton)
        Utilities.styleFilledButton(seeFuelRecordsButton)
        Utilities.styleFilledButton(addServiceButton)
        Utilities.styleFilledButton(addFuelButton)
    }
    
    // MARK: - Firestore data loading for selected car
    func loadCarData() {
        
        let selectedCar = db.collection("users").document(Constants.Authentication.user).collection("cars").document(carID)
        
        selectedCar.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                // Create cleaned data from query
                let data = document.data()!
                let carNickname = data["carnickname"] as? String ?? ""
                let carMake = data["make"] as? String ?? ""
                let carModel = data["model"] as? String ?? ""
                let carYear = data["year"] as? String ?? ""
                let carOdometer = data["odometer"] as? String ?? ""
                let carLicensePlateNumber = data["licenseplatenumber"] as? String ?? ""
                let carVin = data["vinnumber"] as? String ?? ""
                let carRegistrationDate = data["registrationdate"] as? String ?? ""
                let carColor = data["carcolor"] as? String ?? ""
                
                // Assign label text to cleaned data
                self.carNicknameLabel.text = carNickname
                self.carMakeLabel.text = carMake
                self.carModelLabel.text = carModel
                self.carYearLabel.text = carYear
                self.carOdometerLabel.text = carOdometer
                self.carLicensePlateLabel.text = carLicensePlateNumber
                self.carVinLabel.text = carVin
                self.carRegistrationDateLabel.text = carRegistrationDate
                self.carColorLabel.text = carColor
                
                // Debug info
                print("Car Nickname test: \(carNickname)")
                print("Document data: \(dataDescription)")
            } else {
                print("Error reading document")
            }
        }
    }
    
    // MARK: - Segue Transitioners
    
    // Transition to Add Service/Fuel VC and Service/Fuel List VC, passing the carID
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Add Service Record VC
        if segue.identifier == Constants.Storyboard.addServiceRecordSegueIdentifier {
            if let destVC = segue.destination as? AddServiceViewController {
                destVC.carID = self.carID
            }
            
            // Service Record List VC
        } else if segue.identifier == Constants.Storyboard.serviceRecordsListSegueIdentifier {
            if let destVC = segue.destination as? ServiceListViewController {
                destVC.carID = self.carID
            }
            
            // Add Fuel Record VC
        } else if segue.identifier == Constants.Storyboard.addFuelRecordSegueIdentifier {
            if let destVC = segue.destination as? AddFuelViewController {
                destVC.carID = self.carID
            }
            
            // Fuel Record List VC
        } else if segue.identifier == Constants.Storyboard.fuelRecordsListSegueIdentifier {
            if let destVC = segue.destination as? FuelListViewController {
                destVC.carID = self.carID
            }
        }
    }
    
    // MARK: - Add Records Segue Transition
    @IBAction func addServiceRecordTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Storyboard.addServiceRecordSegueIdentifier, sender: self)
    }
    
    @IBAction func addFuelRecordTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Storyboard.addFuelRecordSegueIdentifier, sender: self)
    }
    
    // MARK: - See Records List Segue Transition
    @IBAction func seeServiceRecordsTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Storyboard.serviceRecordsListSegueIdentifier, sender: self)
    }
    
    @IBAction func seeFuelRecordsTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Storyboard.fuelRecordsListSegueIdentifier, sender: self)
    }
    
    
}
