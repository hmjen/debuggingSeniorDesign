//
//  BLEManager.swift
//  try2
//
//  Created by Jennings, Hannah on 5/9/23.
//

import Foundation
import CoreBluetooth


class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var myPeripheral: CBPeripheral!
    var myCentral: CBCentralManager!
    @Published var isSwitchedOn = false
    
        override init() {
            super.init()
     
            myCentral = CBCentralManager(delegate: self, queue: nil)
            myCentral.delegate = self
        }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
         if central.state == .poweredOn {
             isSwitchedOn = true
             myCentral.scanForPeripherals(withServices: nil, options: nil)
         }
         else {
             isSwitchedOn = false
         }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
       
        if let name = peripheral.name {
            if name == "Bt04-A" {
                self.myCentral.stopScan()
                self.myPeripheral.delegate = self
                self.myCentral.connect(peripheral, options: nil)
                
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        self.myPeripheral.discoverServices(nil)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            print("*******************************************************")

            if ((error) != nil) {
                print("Error discovering services: \(error!.localizedDescription)")
                return
            }
            guard let services = peripheral.services else {
                return
            }
            //We need to discover the all characteristic
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            print("Discovered Services: \(services)")
        }
    
    
}
