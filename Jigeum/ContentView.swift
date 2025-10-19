import SwiftUI
internal import _LocationEssentials
internal import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var searchResult: String = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Group {
                    if let location = locationManager.location {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("현재 위치")
                                .font(.headline)
                            Text("위도: \(location.coordinate.latitude, specifier: "%.4f")")
                            Text("경도: \(location.coordinate.longitude, specifier: "%.4f")")
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                    } else if let error = locationManager.error {
                        Text("\(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Text("위치 정보를 가져오는 중...")
                            .foregroundColor(.gray)
                    }
                }
                
                if locationManager.authorizationStatus == .notDetermined {
                    Button {
                        locationManager.requestPermission()
                    } label: {
                        Label("위치 권한 요청", systemImage: "location.circle")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                if locationManager.location != nil {
                    Button {
                        testAPI()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Label("카페 검색 테스트", systemImage: "magnifyingglass")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(isLoading)
                }
                
                if !searchResult.isEmpty {
                    ScrollView {
                        Text(searchResult)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("jigeum")
        }
    }
    
    private func testAPI() {
        guard let location = locationManager.location else {
            searchResult = "위치 정보 없음"
            return
        }
        
        isLoading = true
        searchResult = "검색 중..."
        
        Task {
            do {
                let now = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let timeString = formatter.string(from: now)
                
                let result = try await APIService.shared.searchCafes(
                    lat: location.coordinate.latitude,
                    lng: location.coordinate.longitude,
                    time: timeString,
                    radius: 1000,
                    page: 0,
                    size: 10
                )
                
                await MainActor.run {
                    searchResult = """
                    검색 성공!
                    
                    총 \(result.totalElements)건
                    
                    결과 (상위 \(result.content.count)개):
                    \(result.content.map { "• \($0.name)" }.joined(separator: "\n"))
                    """
                    isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    searchResult = "에러: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
