//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Ryan on 22/09/2025.
//

import SwiftUI

struct AddressView: View {
    // Current instance of the order
    @Bindable var order: Order
    
    var body: some View {
        Form {
            // enter customers details
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            // To checkout view
            Section {
                NavigationLink("Check out") {
                    // the actual checkoutview
                    // take with it the order details
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
