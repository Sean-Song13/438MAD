//
//  ViewController.swift
//  XinhaoSong-Lab1
//
//  Created by xinhao.song on 2021/9/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var originalPriceInputField: UITextField!
    @IBOutlet weak var discountInputField: UITextField!
    @IBOutlet weak var salesTaxInputField: UITextField!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var originalPrice: Float?
    var discount: Float?
    var salesTax: Float?
    
    var illegalFieldIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        originalPrice = 0.0
        discount = 0.0
        salesTax = 0.0
        // Do any additional setup after loading the view.
    }

    
    @IBAction func OnOriginalPriceChanged(_ sender: Any) {
        HideIllegalInputError()
//        var tempText = originalPriceInputField.text ?? ""
//        if tempText.starts(with: "-"){
//            tempText = "-0.0"
//        }
//        originalPrice = tempText.isEmpty ? 0.0 : Float(tempText)
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
//        var tempText = discountInputField.text ?? ""
//        if tempText.starts(with: "-"){
//            tempText = "-0.0"
//        }
//        discount = tempText.isEmpty ? 0.0 : Float(tempText)
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
//        var tempText = salesTaxInputField.text ?? ""
//        if tempText.starts(with: "-"){
//            tempText = "-0.0"
//        }
//        salesTax = tempText.isEmpty ? 0.0 : Float(tempText)
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

