import SwiftUI

struct CafeListView: View {
    let cafes: [Cafe]
    
    var body: some View {
        List(cafes) { cafe in
            NavigationLink {
                CafeDetailView(cafe: cafe)
            } label: {
                CafeRowView(cafe: cafe)
            }
        }
        .listStyle(.plain)
    }
}

struct CafeRowView: View {
    let cafe: Cafe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(cafe.name)
                .font(.headline)
            
            if let address = cafe.address {
                Text(address)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.orange)
                    .font(.caption)
                
                Text("위도: \(cafe.latitude, specifier: "%.4f"), 경도: \(cafe.longitude, specifier: "%.4f")")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}
