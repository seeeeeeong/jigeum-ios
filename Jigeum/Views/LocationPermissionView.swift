import SwiftUI

struct LocationPermissionView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "location.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("위치 권한이 필요합니다")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("주변 카페를 찾기 위해\n위치 권한을 허용해주세요")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("1.")
                        .fontWeight(.bold)
                    Text("설정 앱을 엽니다")
                }
                HStack {
                    Text("2.")
                        .fontWeight(.bold)
                    Text("지금영업중 → 위치")
                }
                HStack {
                    Text("3.")
                        .fontWeight(.bold)
                    Text("'앱 사용 중'을 선택합니다")
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                HStack {
                    Image(systemName: "gear")
                    Text("설정으로 이동")
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
