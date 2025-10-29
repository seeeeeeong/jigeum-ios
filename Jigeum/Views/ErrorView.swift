import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("오류가 발생했습니다")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: retry) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("다시 시도")
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct EmptyResultView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cup.and.saucer")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("검색 결과가 없습니다")
                .font(.headline)
            
            Text("다른 시간이나 반경으로\n다시 검색해보세요")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: onDismiss) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("다시 검색")
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}
