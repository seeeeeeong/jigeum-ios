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
                MapView(cafes: cafes, region: $region)
                
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
                    EmptyResultView()
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
        guard let location = locationManager.location else {
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
                
                let result = try await APIService.shared.searchCafes(
                    lat: location.coordinate.latitude,
                    lng: location.coordinate.longitude,
                    time: timeString,
                    radius: searchRadius,
                    page: 0,
                    size: 50
                )
                
                await MainActor.run {
                    cafes = result.content
                    if !cafes.isEmpty {
                        region.center = location.coordinate
                    }
                    isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = "검색 중 오류가 발생했습니다.\n네트워크 연결을 확인해주세요."
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
