//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Ryan on 21/09/2025.
//

import SwiftUI

struct ContentView: View {
    // creation of orders
    @State private var order: Order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                // pick cake type/amount
                Section {
                    // pick cake type
                    Picker("Select your cake type", selection: $order.type){
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    // pick number of cakes wanted
                    Stepper("Number of cakes \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                // special request to cakes
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)
                    
                    // if user wants special requests for an order
                    if order.specialRequestEnabled {
                        Toggle("Add Extra Frosting", isOn: $order.extraFrosting)
                        
                        Toggle("Add Sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                // Navigate to a new view for order details
                Section {
                    NavigationLink("Delivery Details") {
                        // the view to navigate
                        // take with it the order details
                        AddressView(order: order)
                    }
                    .navigationTitle("DaCakeShop")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

