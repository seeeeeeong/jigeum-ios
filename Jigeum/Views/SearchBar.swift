import SwiftUI

struct SearchBar: View {
    @Binding var searchRadius: Int
    @Binding var searchTime: Date
    var onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("검색 반경")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Picker("", selection: $searchRadius) {
                    Text("500m").tag(500)
                    Text("1km").tag(1000)
                    Text("2km").tag(2000)
                    Text("5km").tag(5000)
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("영업 시간")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                DatePicker("", selection: $searchTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            
            Button(action: onSearch) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
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
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
