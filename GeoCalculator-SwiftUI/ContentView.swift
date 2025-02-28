//
//  ContentView.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 1/30/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 6
        return formatter
    }()
    enum FocusedField {
        case lat1, lng1, lat2, lng2
    }
    @State private var lat1:Double?
    @State private var lng1: Double?
    @State private var lat2: Double?
    @State private var lng2: Double?
    @State private var distanceStr = ""
    @State private var bearingStr = ""
    @FocusState private var focusedField: FocusedField?
    var body: some View {
        ZStack {
            Color.white.opacity(0.0000001)
            VStack {
                HStack {
                    TextField("Enter latitude", value: $lat1, formatter: numberFormatter)
                        .focused($focusedField, equals: .lat1)
                    TextField("Enter longitude", value: $lng1, formatter: numberFormatter)
                        .focused($focusedField, equals: .lng1)
                }
                
                HStack {
                    TextField("Enter latitude", value: $lat2, formatter: numberFormatter)
                        .focused($focusedField, equals: .lat2)
                    TextField("Enter longitude", value: $lng2, formatter: numberFormatter)
                        .focused($focusedField, equals: .lng2)
                }
                HStack {
                    Button("Calculate") {
                        doCalculatations()
                    }
                    .disabled(lat1?.isNaN ?? true || lng1?.isNaN ?? true || lat2?.isNaN ?? true || lng2?.isNaN ?? true)
                    Spacer()
                    Button("Clear") {
                        lat1 = nil
                        lat2 = nil
                        lng1 = nil
                        lng2 = nil
                        focusedField = nil
                    }
                    
                }
                Spacer()
                    .frame(height: 20)
                HStack {
                    Text(distanceStr)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack{
                    Text(bearingStr)
                        .fontWeight(.bold)
                    Spacer()
                }
                Spacer()
            }
            .textFieldStyle(SignedDecimalFieldStyle())
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    
                    // minus toggle button
                    Button {
                        switch(focusedField) {
                        case .lat1:
                            if let l = lat1 {
                                lat1 = l * -1
                            }
                        case .lng1:
                            if let l = lng1 {
                                lng1 = l * -1
                            }
                        case .lat2:
                            if let l = lat2 {
                                lat2 = l * -1
                            }
                        case .lng2:
                            if let l = lng2 {
                                lng2 = l * -1
                            }
                        default:
                            break
                        }
                        
                    } label: {
                        Image(systemName: "minus.square")
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                }
                ToolbarItem(placement: .keyboard) {
                    
                    // keyboard dismiss button
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
            .padding()
        }
        .onTapGesture {
            print("Tap")
            focusedField = nil
        }
        
    }

    func doCalculatations()
    {
        guard let p1lt = lat1, let p1ln = lng1, let p2lt = lat2, let p2ln = lng2  else {
            return
        }
        print("(\(p1lt),\(p1ln)) -- (\(p2lt), \(p2ln))")
        let p1 = CLLocation(latitude: p1lt, longitude: p1ln)
        let p2 = CLLocation(latitude: p2lt, longitude: p2ln)
        
        let distance = p1.distance(from: p2) / 10.0
        distanceStr = "Distance: \(distance.rounded() / 100.0) kilometers"
        
        let bearing = (p1.bearingToPoint(point: p2) * 100.0).rounded() / 100.0
        bearingStr = "Bearing: \(bearing) degrees"
        
    }
}

#Preview {
    ContentView()
}


