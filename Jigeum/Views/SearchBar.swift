import SwiftUI

struct SearchBar: View {
    @Binding var searchRadius: Int
    @Binding var searchTime: Date
    var onSearch: () -> Void

    private var radiusText: String {
        if searchRadius >= 1000 {
            return "\(searchRadius / 1000)km"
        } else {
            return "\(searchRadius)m"
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // 검색 반경
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "circle.dashed")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("검색 반경")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(radiusText)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }

                Picker("", selection: $searchRadius) {
                    Text("500m").tag(500)
                    Text("1km").tag(1000)
                    Text("2km").tag(2000)
                    Text("5km").tag(5000)
                }
                .pickerStyle(.segmented)
            }

            Divider()

            // 영업 시간
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("영업 시간")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                DatePicker("", selection: $searchTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 검색 버튼
            Button(action: onSearch) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.body)
                    Text("검색하기")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
    }
}
