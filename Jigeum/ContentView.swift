import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cafes: [Cafe] = []
    @State private var isLoading = false
    @State private var showsList = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var hasSearched = false
    @State private var searchRadius = 1000
    @State private var searchTime = Date()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.4979, longitude: 127.0276),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView(cafes: cafes, region: $region, searchRadius: $searchRadius)
                
                VStack {
                    SearchBar(
                        searchRadius: $searchRadius,
                        searchTime: $searchTime,
                        onSearch: performSearch
                    )
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button {
                            moveToCurrentLocation()
                        } label: {
                            Image(systemName: "location.fill")
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        
                        Spacer()
                        
                        if !cafes.isEmpty {
                            Button {
                                showsList = true
                            } label: {
                                HStack {
                                    Image(systemName: "list.bullet")
                                    Text("리스트 보기")
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .shadow(radius: 3)
                            }
                        }
                    }
                    .padding()
                }
                
                if isLoading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("검색 중...")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .padding(30)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                }
                if showError, let error = errorMessage {
                    Color.white.edgesIgnoringSafeArea(.all)
                    ErrorView(message: error) {
                        showError = false
                        performSearch()
                    }
                }

                if hasSearched && cafes.isEmpty && !isLoading && !showError {
                    Color.white.edgesIgnoringSafeArea(.all)
                    EmptyResultView {
                        hasSearched = false
                    }
                }
                
                if locationManager.authorizationStatus == .denied ||
                   locationManager.authorizationStatus == .restricted {
                    Color.white.edgesIgnoringSafeArea(.all)
                    LocationPermissionView()
                }
            }
            .navigationTitle("지금영업중")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showsList) {
                NavigationStack {
                    CafeListView(cafes: cafes)
                        .navigationTitle("카페 목록 (\(cafes.count))")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("닫기") {
                                    showsList = false
                                }
                            }
                        }
                }
            }
            .onAppear {
                if locationManager.authorizationStatus == .notDetermined {
                    locationManager.requestPermission()
                }
            }
        }
    }
    
    private func moveToCurrentLocation() {
        if let location = locationManager.location {
            region.center = location.coordinate
        } else {
            locationManager.requestPermission()
        }
    }
    
    private func performSearch() {
        // GPS 위치 확인 (위치 권한용)
        guard locationManager.location != nil else {
            errorMessage = "위치 정보를 가져올 수 없습니다"
            showError = true
            return
        }
        
        isLoading = true
        hasSearched = true
        errorMessage = nil
        
        Task {
            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let timeString = formatter.string(from: searchTime)
                
                // 지도 중심점 좌표 사용
                let searchLat = region.center.latitude
                let searchLng = region.center.longitude
                
                let result = try await APIService.shared.searchCafes(
                    lat: searchLat,
                    lng: searchLng,
                    time: timeString,
                    radius: searchRadius,
                    page: 0,
                    size: 50
                )
                
                await MainActor.run {
                    cafes = result.content
                    isLoading = false
                }
                
            } catch let error as APIError {
                await MainActor.run {
                    switch error {
                    case .invalidURL:
                        errorMessage = "잘못된 서버 주소입니다.\n개발자에게 문의하세요."
                    case .invalidResponse:
                        errorMessage = "서버 응답이 올바르지 않습니다."
                    case .decodingError:
                        errorMessage = "데이터 처리 중 오류가 발생했습니다."
                    case .serverError(let message):
                        errorMessage = "서버 오류: \(message)"
                    }
                    showError = true
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = """
                    네트워크 연결을 확인해주세요.
                    
                    확인사항:
                    1. 백엔드 서버가 실행 중인가요?
                    2. WiFi가 연결되어 있나요?
                    3. 같은 네트워크에 있나요?
                    
                    현재 서버: \(AppConfig.baseURL)
                    """
                    showError = true
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
