//
//  Order.swift
//  CupcakeCorner
//
//  Created by Ryan on 22/09/2025.
//
import SwiftUI
import Observation

@Observable
class Order: Codable {
    // instance of orderdetails
    var userData: OrderDetails = OrderDetails()
    // key to access details for encode/decode
    private var saveKey = "orderDetails"
    
    // when app started grab and instance of user details and load the users current details
    init() { load() }
    
    // computed properties
    // get the users details
    // set the users details with the latest value
    var name: String {
        get { userData.name }
        set { userData.name = newValue; save() }
    }
    var streetAddress: String {
        get { userData.streetAddress }
        set { userData.streetAddress = newValue; save() }
    }
    var city: String {
        get { userData.city }
        set { userData.city = newValue; save() }
    }
    var zip: String  {
        get { userData.zip }
        set { userData.zip = newValue; save() }
    }
    
    var type: Int {
        get { userData.type }
        set { userData.type = newValue; save() }
    }
    // how many cakes user wants
    var quantity: Int {
        get { userData.quantity }
        set { userData.quantity = newValue; save() }
    }
    
    // whether special requests are wanted
    var specialRequestEnabled: Bool {
        get { userData.specialRequestEnabled }
        set { userData.specialRequestEnabled = newValue;
            if !newValue {
                userData.extraFrosting = false
                userData.addSprinkles = false
            }
            save()
        }
    }
    
    var extraFrosting: Bool {
        get { userData.extraFrosting }
        set { userData.extraFrosting = newValue; save()
        }
    }
    
    var addSprinkles: Bool {
        get { userData.addSprinkles }
        set { userData.addSprinkles = newValue; save()
        }
    }
    
    // ensure the input is valid before allowing user to continue
    var hasValidAddress: Bool {
        if hasValidChars(string: name) && hasValidChars(string: streetAddress) && hasValidChars(string: city) && hasValidChars(string: zip) {
            return true
        }
        return false
    }
    
    // ensure a real value has been input instead of just whitespace
    func hasValidChars(string: String) -> Bool {
        if string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }
    
    // types of possible cakes
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var cost: Decimal {
        // £2 per cake
        var cost: Decimal = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // £1 for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // £0.50 for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
    
        return cost
    }
    
    // save user details to userdefaults
    private func save() {
        if let encode = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encode, forKey: saveKey)
        }
    }
        
    // load the user details from the userdefauls
    private func load() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            if let decode = try? JSONDecoder().decode(OrderDetails.self, from: savedData) {
                userData = decode
            }
        }
    }
}
