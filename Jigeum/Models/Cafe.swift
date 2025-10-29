import Foundation
internal import CoreLocation

struct Cafe: Codable, Identifiable {
    let id: Int
    let name: String
    let address: String?
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
