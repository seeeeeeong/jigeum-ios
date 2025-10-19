import SwiftUI
import MapKit

struct MapView: View {
    let cafes: [Cafe]
    @Binding var region: MKCoordinateRegion
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
}
