//
//  SalesTaxModel.swift
//  XinhaoSong-Lab1
//
//  Created by xinhao.song on 2021/9/14.
//

import Foundation

class SalesTaxModel:Codable{
    var salesTaxs: [SalesTax]?
    class SalesTax: Codable {
        var State: String = ""
        var stateTaxRate: String = ""
        var avgLocalTaxRate: String = ""
        var combinedRate: String = ""
        var Pop: Int = 0
    }
}
