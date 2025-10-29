import SwiftUI
import MapKit

struct MapView: View {
    let cafes: [Cafe]
    @Binding var region: MKCoordinateRegion
    @Binding var searchRadius: Int
    @State private var selectedCafe: Cafe?
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: cafes) { cafe in
                MapAnnotation(coordinate: cafe.coordinate) {
                    Button {
                        selectedCafe = cafe
                        showDetail = true
                    } label: {
                        VStack(spacing: 0) {
                            Image(systemName: "cup.and.saucer.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.orange)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                            
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.orange)
                                .offset(y: -5)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                let radiusInPoints = metersToPoints(
                    meters: Double(searchRadius),
                    latitude: region.center.latitude,
                    screenWidth: geometry.size.width,
                    span: region.span.longitudeDelta
                )
                
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: radiusInPoints * 2, height: radiusInPoints * 2)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                VStack(spacing: 0) {
                    Image(systemName: "scope")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .shadow(color: .white, radius: 2)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .allowsHitTesting(false) 
        }
        .sheet(isPresented: $showDetail) {
            if let cafe = selectedCafe {
                NavigationStack {
                    CafeDetailView(cafe: cafe)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("닫기") {
                                    showDetail = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    // 미터를 화면 포인트로 변환
    private func metersToPoints(meters: Double, latitude: Double, screenWidth: Double, span: Double) -> CGFloat {
        // 위도에 따른 미터당 경도 변화 계산
        let metersPerDegree = 111320.0 * cos(latitude * .pi / 180.0)
        let degrees = meters / metersPerDegree
        let ratio = degrees / span
        return CGFloat(ratio * screenWidth)
    }
}
