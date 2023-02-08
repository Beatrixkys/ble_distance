//
//  DistanceController.swift
//  BTPOC
//
//  Created by Beatrix Kang on 12/01/2023.
//

import UIKit
import CoreBluetooth

class DistanceController: UIViewController {
    
    //IB Outlets
    @IBOutlet var bgColor: UIView!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var distanceTemp: UILabel!
    @IBOutlet weak var distanceMeters: UILabel!
    @IBOutlet weak var signalStrength: UILabel!
    @IBOutlet weak var rssiValue: UILabel!
    @IBOutlet weak var timerCountdown: UILabel!
    
    
    //Bluetooth Variables
    var btManager : BTManager!
    var device : BTModel?
    
    //Timer Variables
    var timer = Timer()
    var result = 7
    
    
    
    override func viewDidLoad() {
        //setting up the variables
        super.viewDidLoad()
        btManager = BTManager()
        btManager.centralManager = CBCentralManager(delegate: self, queue: nil)
        
        //null check
        if device != nil {
            timerShow()
            setValues(rssiVal: device!.rssi)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //end the Timer before pushing it back
        timerEnd()
        super.viewDidDisappear(true)
    }
    
    //to reload the view and set the values
    //send the rssi value into the function
    func setValues( rssiVal: Int ){
        deviceName.text = device?.name
        distanceTemp.text = device?.distanceTemp
        bgColor.backgroundColor = device?.distanceColor
        distanceMeters.text = String("\(device!.distance)m")
        signalStrength.text = device?.signalStrength
        rssiValue.text = String(rssiVal)
    }
    
    
   

}


extension DistanceController{
    func timerShow() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        //example functionality
        if result > -1 {
            timerCountdown.text = String (result)
            result -= 1
        } else {
            result = 7
            print ("Device no Updates")
            btManager.stopScan()
            btManager.startScanning(uuid:CBUUIDs.BLEService_UUID)
            
        }
    }

    func timerEnd(){
        //timer = timerEnd()
        timer.invalidate()
        //timer.invalidate()
        btManager.centralManager.stopScan()
    }
}


extension DistanceController: CBPeripheralDelegate {
    
    
}


extension DistanceController : CBCentralManagerDelegate{
    
    //Did discover implemenatation
    
    func centralManager(_ central: CBCentralManager, didDiscover peri: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {

        btManager.peripheralUsed = peri
        btManager.peripheralUsed.delegate = self
        let uid = UUID (uuidString: device!.name)
        if (uid == peri.identifier) {
            
            device?.rssi = Int(truncating: RSSI)
            setValues(rssiVal: Int(truncating: RSSI))
            btManager.centralManager.stopScan()
            print ("Scan Stopped")
            result = 7
            
        }
       
       }
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        btManager.centralManagerDidUpdateState( btManager.centralManager)
    }

    }
    
    



