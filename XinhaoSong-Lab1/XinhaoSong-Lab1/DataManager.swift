//
//  DataManager.swift
//  XinhaoSong-Lab1
//
//  Created by xinhao.song on 2021/9/14.
//

import Foundation

class DataManager {
    
struct SalesTaxData: Codable {
    var State: String
    var stateTaxRate: String
    var avgLocalTaxRate: String
    var combinedRate: String
    var Pop: Int
}

struct SalesTaxDataList: Codable{
    let list: [SalesTaxData]
}
    
    var localSalesTaxDataList:SalesTaxDataList?
    var taxDict = [String:Float]()
    
    private func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}

private func Parse(jsonData: Data) {
    do {
        let decodedData = try JSONDecoder().decode(SalesTaxDataList.self,from: jsonData)
        self.localSalesTaxDataList = decodedData
//        print("Title: ", decodedData.title)
//        print("Description: ", decodedData.description)
//        print("===================================")
    } catch {
        print("decode error")
    }
}
    
    public func RequireSalesTax(stateName: String) -> Float{
        if (localSalesTaxDataList == nil){
           Parse(jsonData: readLocalFile(forName: "data")!)
            if let dataList = localSalesTaxDataList {
                for data in dataList.list {
                    taxDict.updateValue(Float(data.combinedRate) ?? 0.0, forKey: data.State)
                }
            }
        }
        if taxDict.keys.contains(stateName){
            return taxDict[stateName]!
        }
        return -1
    }
}
