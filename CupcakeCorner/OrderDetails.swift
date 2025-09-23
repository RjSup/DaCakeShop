import SwiftUI
import Observation

// Simple data model that conforms to Codable
struct OrderDetails: Codable {
    var name: String = ""
    var streetAddress: String = ""
    var city: String = ""
    var zip: String = ""
    var type: Int = 0
    var quantity: Int = 3
    var specialRequestEnabled: Bool = false
    var extraFrosting: Bool = false
    var addSprinkles: Bool = false
}
