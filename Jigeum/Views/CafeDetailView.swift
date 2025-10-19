import SwiftUI
import MapKit

struct CafeDetailView: View {
    let cafe: Cafe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 지도 미리보기
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
                
                // 카페 정보
                VStack(alignment: .leading, spacing: 16) {
                    Text(cafe.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let address = cafe.address {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.orange)
                            Text(address)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.orange)
                        Text("위도: \(cafe.latitude, specifier: "%.6f")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.orange)
                        Text("경도: \(cafe.longitude, specifier: "%.6f")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // 길찾기 버튼
                    Button {
                        openInMaps()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                            Text("길찾기")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("카페 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openInMaps() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: cafe.coordinate))
        mapItem.name = cafe.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
