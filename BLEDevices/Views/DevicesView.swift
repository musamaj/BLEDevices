//
//  ContentView.swift
//  BLEDevices
//
//  Created by Usama Jamil on 7/18/25.
//

import SwiftUI

struct DevicesView: View {
    @StateObject private var bleManager = BLEManager()
    @State private var selectedPeripheralID: UUID?

    var body: some View {
        NavigationStack {
            VStack {
                List(bleManager.peripherals) { peripheral in
                    NavigationLink(value: peripheral.id) {
                        VStack(alignment: .leading) {
                            Text(peripheral.name).font(.headline)
                            Text("RSSI: \(peripheral.rssi)")
                            Text("UUID: \(peripheral.id.uuidString)").font(.caption)
                        }
                    }
                }

                HStack {
                    Button("Start Scanning") {
                        bleManager.startScanning()
                    }
                    .padding()

                    Button("Stop Scanning") {
                        bleManager.stopScanning()
                    }
                    .padding()
                }
            }
            .navigationTitle("BLE Devices")
            .navigationDestination(for: UUID.self) { id in
                PeripheralDetailView(bleManager: bleManager, peripheralID: id)
            }
        }
    }
}



#Preview {
    DevicesView()
}
