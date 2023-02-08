//
//  BTManager.swift
//  BTPOC
//
//  Created by Beatrix Kang on 03/02/2023.
//

import Foundation
import CoreBluetooth
class BTManager: CBCentralManager {
    
    
    
    var centralManager: CBCentralManager!
    var peripheralUsed: CBPeripheral!
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //show Pop Up instead of print
        switch central.state {
        case .poweredOff:
            print("Is Powered Off.")
        case .poweredOn:
            print("Is Powered On.")
            //startScanning()
        case .unsupported:
            print("Is Unsupported.")
        case .unauthorized:
            print("Is Unauthorized.")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
            print("Error")
        }
    }
    
    
    //pass in unique uuid in the function
    func startScanning (uuid : CBUUID){
        
        let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey:
                                      NSNumber(value: false)]
        
        //Use Hilti tag UUID to only show hilti tags
        centralManager?.scanForPeripherals(withServices: [uuid], options: options)
        print("Scan Started")
        
    }
    
}

