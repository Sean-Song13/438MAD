//
//  ViewController.swift
//  XinhaoSong-Lab1
//
//  Created by xinhao.song on 2021/9/10.
//

import UIKit
import CoreLocation
import Contacts

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var originalPriceInputField: UITextField!
    @IBOutlet weak var discountInputField: UITextField!
    @IBOutlet weak var salesTaxInputField: UITextField!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var theTaxLabel: UILabel!
    
    var originalPrice: Float?
    var discount: Float?
    var salesTax: Float?
    
    var locationManager: CLLocationManager?
    var illegalFieldIndex = -1
    
    var dataManager: DataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        originalPrice = 0.0
        discount = 0.0
        salesTax = 0.0
        theTaxLabel.alpha = 0
        // Do any additional setup after loading the view.
        
        // Create a CLLocationManager and assign a delegate
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        // Request a user’s location once
//        let status = CLLocationManager.authorizationStatus()
//        if status == .authorizedWhenInUse || status ==  .authorizedAlways
//        {
//            locationManager?.requestLocation()
//        }
        
    }
    

    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
//            print("\(latitude)")
//            print("\(longitude)")
            let location = CLLocation(latitude: latitude, longitude: longitude)
            location.placemark { placemark, error in
                guard let placemark = placemark else {
                    print("Error:", error ?? "nil")
                    return
                }
                print(placemark.administrativeArea ?? "")
                let state = placemark.administrativeArea ?? ""
                var tax = self.dataManager?.RequireSalesTax(stateName: state)
                if tax! < 0{
                    tax = 0.0
                    self.theTaxLabel.text = "No data in \(state)"
                }else{
                    self.theTaxLabel.text = "Tax in \(state) is \(String(format: "%.2f", tax!))"}
                self.theTaxLabel.alpha = 1
                self.salesTaxInputField.text = String(tax!)
                self.salesTax = tax
                self.UpdateFinalPrice()
//                print(placemark.postalAddressFormatted ?? "")
            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
        print("failure to get a user’s location")
    }

    @IBAction func OnOriginalPriceChanged(_ sender: Any) {
        HideIllegalInputError()
        originalPrice = InputInterpretation(input: originalPriceInputField.text)
        if originalPrice == nil{
            RaiseIllegalInputError()
            illegalFieldIndex = 0
            discount = 0.0
            return
        }
//        let finalPrice = CalculateFinalPrice(originOpt: originalPrice, discountOpt: discount, taxOpt: salesTax)
        UpdateFinalPrice()
    }
    
    @IBAction func OnDIscountChanged(_ sender: Any) {
        HideIllegalInputError()
        discount = InputInterpretation(input: discountInputField.text)
        if discount == nil{
            RaiseIllegalInputError()
            illegalFieldIndex = 1
            discount = 0.0
            return
        }
//        let finalPrice = CalculateFinalPrice(originOpt: originalPrice, discountOpt: discount, taxOpt: salesTax)
        UpdateFinalPrice()
    }
    
    @IBAction func OnSalesTaxChanged(_ sender: Any) {
        theTaxLabel.alpha = 0
        HideIllegalInputError()
        salesTax = InputInterpretation(input: salesTaxInputField.text)
        if salesTax == nil{
            RaiseIllegalInputError()
            illegalFieldIndex = 2
            salesTax = 0.0
            return
        }
//        let finalPrice = CalculateFinalPrice(originOpt: originalPrice, discountOpt: discount, taxOpt: salesTax)
        UpdateFinalPrice()
    }
    @IBAction func OnGetCurrentLoc(_ sender: Any) {
        if dataManager == nil{
            self.dataManager = DataManager()
        }
        locationManager?.requestLocation()
    }
    
    func InputInterpretation(input:String?) -> Float? {
        var tempText = input ?? ""
        tempText = tempText == "-" ? "0" : tempText
        let result = tempText.isEmpty ? 0.0 : Float(tempText)
        return result
    }
    
    func CalculateFinalPrice(originOpt: Float?, discountOpt: Float?, taxOpt: Float?) -> Float {
        let finalPrice = originOpt!*(1-discountOpt!/100)*(1+taxOpt!/100)
        return finalPrice
    }
    
    func UpdateFinalPrice(){
        let finalPrice = CalculateFinalPrice(originOpt: originalPrice, discountOpt: discount, taxOpt: salesTax)
        finalPriceLabel.text = "$\(String(format: "%.2f", finalPrice))"
    }
    
    func RaiseIllegalInputError(){
        errorLabel.alpha = 1
    }
    
    func HideIllegalInputError(){
        errorLabel.alpha = 0
        switch illegalFieldIndex {
        case 0:
            originalPriceInputField.text = ""
        case 1:
            discountInputField.text = ""
        case 2:
            salesTaxInputField.text = ""
        default:
            break
        }
        illegalFieldIndex = -1
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

extension CLPlacemark {
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
}
