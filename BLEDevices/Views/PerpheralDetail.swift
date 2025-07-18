//
//  PerpheralDetail.swift
//  BLEDevices
//
//  Created by Usama Jamil on 7/18/25.
//

import SwiftUI

struct PeripheralDetailView: View {
    @ObservedObject var bleManager: BLEManager
    let peripheralID: UUID

    var body: some View {
        VStack(alignment: .leading) {
            if let peripheral = bleManager.peripherals.first(where: { $0.id == peripheralID }) {
                Text("Connected to: \(peripheral.name)").font(.title2).padding(.bottom)
            }

            if bleManager.services.isEmpty {
                Text("Connecting and discovering services...").padding()
            } else {
                List {
                    ForEach(bleManager.services, id: \.uuid) { service in
                        Section(header: Text("Service: \(service.uuid)")) {
                            if let characteristics = service.characteristics {
                                ForEach(characteristics, id: \.uuid) { characteristic in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Characteristic: \(characteristic.uuid)")
                                        HStack {
                                            Button("Read") {
                                                bleManager.read(characteristic: characteristic)
                                            }
                                            .padding(.trailing)

                                            Button("Write") {
                                                bleManager.write("Hello", to: characteristic)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            bleManager.connect(to: peripheralID)
        }
        .navigationTitle("Peripheral Details")
    }
}
