//
//  ViewController.swift
//  BLEPOCFix
//
//  Created by Beatrix Kang on 07/02/2023.
//
import UIKit
import CoreBluetooth

class ViewController: UIViewController {

   
    var btManager : BTManager!
    
    
    @IBOutlet weak var btTable: UITableView!
    //private var centralManager: CBCentralManager!
    //private var peripheralUsed: CBPeripheral!
    
    
    var bts: [BTModel] = []
    var discoveredDevices = [CBPeripheral]()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        btManager = BTManager()
        btTable.delegate = self
        btTable.dataSource = self
        btManager.centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
  
   
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        if btManager.isScanning {
            btManager.centralManager?.stopScan()
            btManager.startScanning(uuid: CBUUIDs.BLEService_UUID)
        } else {
            btManager.startScanning(uuid: CBUUIDs.BLEService_UUID)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.btSegue {
            let destinationVc = segue.destination as! DistanceController
            let deviceIndex = btTable.indexPathForSelectedRow?.row
                destinationVc.device = bts [deviceIndex!]
        }
    }
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        //var content = cell.defaultContentConfiguration()
        
        let bt = bts [indexPath.row]
        content.text = bt.name
        content.secondaryText = String ("\(bt.distance) m ")
        cell.contentConfiguration = content
        
        return cell
    }
    
    func btCardPressed(){
        btManager.centralManager.stopScan()
        bts = []
        btTable.reloadData()
    }
    
    
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btCardPressed()
    }
    
    
}


extension ViewController: CBPeripheralDelegate {
    
    
}

extension ViewController: CBCentralManagerDelegate{
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        btManager.centralManagerDidUpdateState( btManager.centralManager)
    }
    
    
   
   //retain here for function versatility
    func centralManager(_ central: CBCentralManager, didDiscover peri: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {

        

        btManager.peripheralUsed = peri
        btManager.peripheralUsed.delegate = self
        
        if !discoveredDevices.contains(btManager.peripheralUsed){
            bts.append(BTModel(name:  btManager.peripheralUsed.identifier.uuidString,  rssi: Int(truncating: RSSI)))
            discoveredDevices.append(btManager.peripheralUsed)
            print (advertisementData)
            
        }
        
        btTable.reloadData()
        
       }
    
    
    /*
    func centralManager(_ central: CBCentralManager, didConnect peri: CBPeripheral) {
        print ("Did Connect True")
        print (peripheralUsed!)
        print (peripheralUsed!.readRSSI())
        
        //self.centralManager = nil
        //self.peripheralUsed = nil
        
    }*/
    
    
}
