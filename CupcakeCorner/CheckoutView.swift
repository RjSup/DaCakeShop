//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Ryan on 22/09/2025.
//

import SwiftUI

struct CheckoutView: View {
    @Bindable var order: Order
    @State private var confirmationMessage: String? = ""
    @State private var showingConfirmation: Bool = false
    @State private var errorMessage: String? = ""
    @State private var showingError: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                // image from website
                Section {
                    AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                            image
                                .resizable()
                                .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 233)
                }
                
                // Order details
                Section {
                    Text("Cake: \(order.type.description)")
                    Text("Quantity: \(order.quantity.description)")
                    Text("Address: \(order.streetAddress)")
                }
                
                // total price and place order
                Section {
                    Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                        .font(.title)
                    
                    Button("Place Order") {
                        Task {
                            await placeOrder()
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage!)
        }
        .alert("An error occured", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage!)
        }
    }
    
    // send the data to the web server (not really yet)
    func placeOrder() async {
        // encode the order details into JSON
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        // init the url to sublit to
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        // submit a request to the url
        var request = URLRequest(url: url)
        // ensure the submittion conforms to the protocol the web expects
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // ensure the request type is POST
        request.httpMethod = "POST"

        do {
            // wait for a response from the request endoded as JSON
            let _ = try await URLSession.shared.upload(for: request, from: encoded)
            confirmationMessage = "Your order for \(order.quantity)x \(Order.types[order.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            errorMessage = "Error: \(error.localizedDescription). Please try again to order \(order.quantity)x \(Order.types[order.type].lowercased()) cupcakes."
            showingError = true
        }
    }

}

#Preview {
    CheckoutView(order: Order())
}
