//
//  BLEManager+Extension.swift
//  BLEDevices
//
//  Created by Usama Jamil on 7/18/25.
//

import CoreBluetooth

// Connect, Discover Services & Characteristics

extension BLEManager {
    
    func connect(to peripheralID: UUID) {
        if let peripheral = discoveredPeripherals[peripheralID] {
            connectedPeripheral = peripheral
            peripheral.delegate = self
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            self.services = services
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Characteristic: \(characteristic.uuid)")
            // read or write data
            peripheral.readValue(for: characteristic)
            //peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
}
