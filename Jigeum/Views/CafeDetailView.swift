import SwiftUI
import MapKit

struct CafeDetailView: View {
    let cafe: Cafe
    
    @State private var cafeDetail: CafeDetail?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Map(coordinateRegion: .constant(
                    MKCoordinateRegion(
                        center: cafe.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                ), annotationItems: [cafe]) { cafe in
                    MapMarker(coordinate: cafe.coordinate, tint: .orange)
                }
                .frame(height: 200)
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        Text(cafe.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if let detail = cafeDetail, !isLoading {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(detail.isOpenNow ? Color.green : Color.red)
                                    .frame(width: 8, height: 8)
                                Text(detail.isOpenNow ? "영업중" : "영업종료")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(detail.isOpenNow ? .green : .red)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                (detail.isOpenNow ? Color.green : Color.red)
                                    .opacity(0.1)
                            )
                            .cornerRadius(12)
                        }
                    }
                    
                    if let address = cafe.address {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.orange)
                            Text(address)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Divider()
                    
                    if isLoading {
                        HStack {
                            ProgressView()
                            Text("운영시간 불러오는 중...")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else if let detail = cafeDetail, !detail.operatingHours.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.orange)
                                Text("운영시간")
                                    .font(.headline)
                            }
                            
                            ForEach(detail.operatingHours) { hour in
                                HStack {
                                    Text(hour.dayName)
                                        .frame(width: 60, alignment: .leading)
                                        .foregroundColor(hour.isToday ? .primary : .gray)
                                        .fontWeight(hour.isToday ? .bold : .regular)
                                    
                                    Text(hour.displayTime)
                                        .fontWeight(hour.isToday ? .semibold : .regular)
                                        .foregroundColor(hour.isToday ? .primary : .secondary)
                                    
                                    if hour.isToday {
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.orange)
                                            .font(.caption)
                                    }
                                }
                                .font(.body)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(
                                    hour.isToday ? Color.orange.opacity(0.1) : Color.clear
                                )
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(10)
                    } else if let error = errorMessage {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    
                    Divider()

                    // 길찾기 버튼
                    Button {
                        openInMaps()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                .font(.title3)
                            Text("길찾기")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("카페 정보")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadCafeDetail()
        }
    }
    
    private func loadCafeDetail() async {
        isLoading = true
        errorMessage = nil
        
        do {
            cafeDetail = try await APIService.shared.getCafeDetail(cafeId: cafe.id)
            isLoading = false
        } catch {
            errorMessage = "운영시간을 불러올 수 없습니다"
            isLoading = false
        }
    }
    
    private func openInMaps() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: cafe.coordinate))
        mapItem.name = cafe.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
