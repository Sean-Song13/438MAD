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
    
    var originalPrice: Float?
    var discount: Float?
    var salesTax: Float?
    
    var locationManager: CLLocationManager?
    var salesTaxs: [SalesTaxModel.SalesTax]?
    var illegalFieldIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        originalPrice = 0.0
        discount = 0.0
        salesTax = 0.0
        // Do any additional setup after loading the view.
        
        ReadSalesTaxFromJson()
        
        print(salesTaxs?.count)
        
        // Create a CLLocationManager and assign a delegate
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        // Request a user’s location once
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status ==  .authorizedAlways
        {
            locationManager?.requestLocation()
        }
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
//                print(placemark.postalAddressFormatted ?? "")
            }
        }
    }
    
    func ReadSalesTaxFromJson() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {return}
        let localData = NSData.init(contentsOfFile: path)! as Data
        do{
            let allSalesTax = try JSONDecoder().decode(SalesTaxModel.self, from: localData)
            if let salesTaxs = allSalesTax.salesTaxs {
                self.salesTaxs = salesTaxs
            }
        }catch{
            debugPrint("json decode failed")
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
        let finalPrice = CalculateFinalPrice(originOpt: originalPrice, discountOpt: discount, taxOpt: salesTax)
        UpdateFinalPrice(finalPrice: finalPrice)
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
        let finalPrice = CalculateFinalPrice(originOpt: originalPrice, discountOpt: discount, taxOpt: salesTax)
        UpdateFinalPrice(finalPrice: finalPrice)
    }
    
    @IBAction func OnSalesTaxChanged(_ sender: Any) {
        HideIllegalInputError()
        salesTax = InputInterpretation(input: salesTaxInputField.text)
        if salesTax == nil{
            RaiseIllegalInputError()
            illegalFieldIndex = 2
            salesTax = 0.0
            return
        }
        let finalPrice = CalculateFinalPrice(originOpt: originalPrice, discountOpt: discount, taxOpt: salesTax)
        UpdateFinalPrice(finalPrice: finalPrice)
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
    
    func UpdateFinalPrice(finalPrice: Float){
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
