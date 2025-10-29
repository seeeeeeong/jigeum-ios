import Foundation

enum AppConfig {
    // MARK: - API Configuration
    
    #if targetEnvironment(simulator)

    static let baseURL = "http://localhost:8080/api/v1"
    #else

    static let baseURL = "http://192.168.0.255:8080/api/v1"
    #endif
    
    // MARK: - Helper
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Print Configuration
    static func printConfig() {
        print("=== App Configuration ===")
        print("Environment: \(isSimulator ? "Simulator" : "Device")")
        print("Base URL: \(baseURL)")
        print("========================")
    }
}
