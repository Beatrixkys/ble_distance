//
//  BTModel.swift
//  BLEPOCFix
//
//  Created by Beatrix Kang on 07/02/2023.
//

//
//  BTModel.swift
//  BTPOC
//
//  Created by Beatrix Kang on 17/01/2023.
//

import Foundation
import UIKit
import CoreBluetooth

struct BTModel{
    let name : String
    var rssi : Int
    
    init (name: String, rssi: Int){
        self.name = name
        self.rssi = rssi
    }
    
    //Convert RSSI and pass to here
    //reference old code
    var distance : Double {
        let envFactor = 2
        let measuredPower = -69
        let fEquation = Double (measuredPower - rssi)
        let sEquation = Double (10 * envFactor)
        let rssiValue =  fEquation / sEquation
        //print (rssiValue)
        //print (Double (10 ^ Int((rssiValue))))
        let distance = Double(pow (10, (rssiValue)))
        return round(distance * 100) / 100.0
        
    }
    
    
    
    
    //use signal strength to return
    var signalStrength : String {
        switch rssi{
        case ...(-90):
                return "Weaker"
        case -90 ... -68:
                return "Weak"
        case -67 ... -61:
            return "Strong"
        default:
            return "Stronger"
        }
    }
    
    var distanceTemp : String {
        switch rssi{
        case ...(-90):
                return "Colder"
        case -90 ... -68:
                return "Cold"
        case -67 ... -61:
            return "Hot"
        default:
            return "Hotter"
        }
    }
    
    var distanceColor : UIColor {
        switch rssi{
        case ...(-90):
            return UIColor.blue
        case (-90) ... (-68):
            return UIColor.blue
        case -67 ... -61:
            return UIColor.red
        default:
            return UIColor.red
        }
    }
    
    
//    var conditionName: String{
//        switch conditionId {
//        case 200...232:
//            return "cloud.bolt"
//        case 300...321:
//            return "cloud.drizzle"
//        case 500...531:
//            return "cloud.rain"
//        case 600...622:
//            return "cloud.snow"
//        case 701...781:
//            return "cloud.fog"
//        case 800:
//            return "sun.max"
//        case 801...804:
//            return "cloud.bolt"
//        default:
//            return "cloud"
//
//        }
//    }
    
}


struct CBUUIDs{

    //6e400001-b5a3-f393-e0a9-e50e24dcca9e
    //4145CF11-DEBC-8997-83D5-C05EC7E7A0C9
    //00001801-0000-1000-8000-00805f9b34fb
    static let kBLEService_UUID = "00001801-0000-1000-8000-00805f9b34fb"
    
    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    

}


