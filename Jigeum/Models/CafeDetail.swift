import Foundation

struct CafeDetail: Codable {
    let id: Int
    let name: String
    let address: String?
    let latitude: Double
    let longitude: Double
    let operatingHours: [OperatingHour]
    
    var isOpenNow: Bool {
        let now = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: now) - 1
        let currentTime = calendar.dateComponents([.hour, .minute], from: now)
        
        guard let hour = currentTime.hour,
              let minute = currentTime.minute,
              let todayHours = operatingHours.first(where: { $0.dayOfWeek == dayOfWeek }) else {
            return false
        }
        
        return todayHours.isOpen(hour: hour, minute: minute)
    }
    
    var todayOperatingHour: OperatingHour? {
        let dayOfWeek = Calendar.current.component(.weekday, from: Date()) - 1
        return operatingHours.first(where: { $0.dayOfWeek == dayOfWeek })
    }
}

struct OperatingHour: Codable, Identifiable {
    var id: Int { dayOfWeek }
    
    let dayOfWeek: Int
    let dayName: String
    let openTime: String
    let closeTime: String
    
    var displayTime: String {
        "\(openTime) - \(closeTime)"
    }
    
    var isToday: Bool {
        let today = Calendar.current.component(.weekday, from: Date()) - 1
        return dayOfWeek == today
    }
    
    func isOpen(hour: Int, minute: Int) -> Bool {
        let currentMinutes = hour * 60 + minute
        
        let openComponents = openTime.split(separator: ":").compactMap { Int($0) }
        let closeComponents = closeTime.split(separator: ":").compactMap { Int($0) }
        
        guard openComponents.count == 2, closeComponents.count == 2 else {
            return false
        }
        
        let openMinutes = openComponents[0] * 60 + openComponents[1]
        let closeMinutes = closeComponents[0] * 60 + closeComponents[1]
        
        if closeMinutes < openMinutes {
            return currentMinutes >= openMinutes || currentMinutes < closeMinutes
        }
        
        return currentMinutes >= openMinutes && currentMinutes < closeMinutes
    }
}
