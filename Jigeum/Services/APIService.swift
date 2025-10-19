import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}

class APIService {
    static let shared = APIService()
    
    private let baseURL = "http://172.30.1.54:8080/api/v1"
    
    private init() {}
    
    func searchCafes(
        lat: Double,
        lng: Double,
        time: String,
        radius: Int = 1000,
        page: Int = 0,
        size: Int = 20
    ) async throws -> PageResponse<Cafe> {
        
        var components = URLComponents(string: "\(baseURL)/cafes/search")!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lng", value: String(lng)),
            URLQueryItem(name: "radius", value: String(radius)),
            URLQueryItem(name: "time", value: time),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size))
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        print("API Request: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("Response Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError("Status: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(
                APIResponse<PageResponse<Cafe>>.self,
                from: data
            )
            
            guard let pageData = apiResponse.data else {
                throw APIError.serverError("No data in response")
            }
            
            print("Found \(pageData.content.count) cafes")
            return pageData
            
        } catch {
            print("Decoding Error: \(error)")
            throw APIError.decodingError
        }
    }
}
