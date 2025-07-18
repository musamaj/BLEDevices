//
//  BLEManager.swift
//  BLEDevices
//
//  Created by Usama Jamil on 7/18/25.
//

import CoreBluetooth
import Foundation

class BLEManager: NSObject, ObservableObject, CBPeripheralDelegate {
    @Published var isScanning = false
    @Published var peripherals: [Peripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var services: [CBService] = []

    var centralManager: CBCentralManager!
    var discoveredPeripherals: [UUID: CBPeripheral] = [:]

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("Bluetooth is not available.")
        }
    }

    func startScanning() {
        peripherals.removeAll()
        discoveredPeripherals.removeAll()
        isScanning = true
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        isScanning = false
        centralManager.stopScan()
    }
    
    func read(characteristic: CBCharacteristic) {
        connectedPeripheral?.readValue(for: characteristic)
    }

    func write(_ string: String, to characteristic: CBCharacteristic) {
        guard let peripheral = connectedPeripheral,
              let data = string.data(using: .utf8),
              characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) else {
            print("Cannot write to characteristic \(characteristic.uuid)")
            return
        }

        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value,
           let stringValue = String(data: value, encoding: .utf8) {
            print("Received from \(characteristic.uuid): \(stringValue)")
        }
    }
}


extension BLEManager: CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        discoveredPeripherals[peripheral.identifier] = peripheral

        let newPeripheral = Peripheral(
            id: peripheral.identifier,
            name: peripheral.name ?? "Unknown",
            rssi: RSSI.intValue
        )

        if !peripherals.contains(where: { $0.id == newPeripheral.id }) {
            peripherals.append(newPeripheral)
        }
    }
}
