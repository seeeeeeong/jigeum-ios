import SwiftUI
import CoreLocation

struct CafeListView: View {
    let cafes: [Cafe]
    @State private var userLocation: CLLocation?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(cafes) { cafe in
                    NavigationLink {
                        CafeDetailView(cafe: cafe)
                    } label: {
                        CafeCardView(cafe: cafe, userLocation: userLocation)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            if let location = LocationManager().location {
                userLocation = location
            }
        }
    }
}

struct CafeCardView: View {
    let cafe: Cafe
    let userLocation: CLLocation?

    private var distance: String {
        guard let userLocation = userLocation else {
            return ""
        }
        let cafeLocation = CLLocation(latitude: cafe.latitude, longitude: cafe.longitude)
        let distanceInMeters = userLocation.distance(from: cafeLocation)

        if distanceInMeters < 1000 {
            return "\(Int(distanceInMeters))m"
        } else {
            return String(format: "%.1fkm", distanceInMeters / 1000)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 헤더: 이름과 거리
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(cafe.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    if !distance.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text(distance)
                                .font(.subheadline)
                                .foregroundColor(.orange)
                                .fontWeight(.semibold)
                        }
                    }
                }

                Spacer()

                Image(systemName: "cup.and.saucer.fill")
                    .font(.title2)
                    .foregroundColor(.orange.opacity(0.8))
            }

            Divider()

            // 주소
            if let address = cafe.address {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 16)

                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }

            // 하단: 상세보기 버튼
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("상세보기")
                        .font(.caption)
                        .fontWeight(.medium)
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                }
                .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}
