//
//  Peripheral.swift
//  BLEDevices
//
//  Created by Usama Jamil on 7/18/25.
//

import Foundation

struct Peripheral: Identifiable {
    let id: UUID
    let name: String
    let rssi: Int
}
