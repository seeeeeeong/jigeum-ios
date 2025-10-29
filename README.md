# 지금영업중 iOS 앱 - 완전판 🚀

## 📁 프로젝트 구조

```
Jigeum/
├── JigeumApp.swift           # 앱 진입점
├── ContentView.swift         # 메인 화면
├── Info.plist               # HTTP 허용 설정 포함
├── Models/                  # 데이터 모델
│   ├── Cafe.swift
│   ├── CafeDetail.swift     # 운영시간 포함
│   └── APIResponse.swift
├── Services/                # 네트워크 & 설정
│   ├── APIService.swift
│   └── AppConfig.swift      # ✅ IP: 192.168.0.255
├── Utils/                   # 유틸리티
│   └── LocationManager.swift
└── Views/                   # UI 컴포넌트
    ├── MapView.swift
    ├── CafeListView.swift
    ├── CafeDetailView.swift # 운영시간 UI
    ├── SearchBar.swift
    ├── ErrorView.swift
    └── LocationPermissionView.swift
```

## 🚀 빠른 시작

### 1. 백엔드 서버 실행 확인
```bash
# 백엔드 프로젝트에서
./gradlew bootRun

# 서버가 8080 포트에서 실행되어야 함
```

### 2. Xcode에서 프로젝트 열기
```bash
# 기존 Xcode 프로젝트를 열고
# Jigeum 폴더의 모든 파일을 프로젝트에 복사
```

### 3. 파일 추가 방법

#### Option A: 드래그 앤 드롭 (추천)
1. Xcode 프로젝트를 엽니다
2. 압축 해제한 `Jigeum` 폴더를 Xcode 프로젝트 네비게이터로 드래그
3. 옵션 선택:
   - ✅ "Copy items if needed" 체크
   - ✅ "Create groups" 선택
   - ✅ Target에 "Jigeum" 체크
4. "Finish" 클릭

#### Option B: 수동 복사
```bash
# 터미널에서
cp -r Jigeum/* /path/to/your/Xcode/Project/Jigeum/
```

### 4. Info.plist 설정 확인

Xcode에서 Target → Info 탭 확인:
- ✅ App Transport Security Settings
  - Allow Arbitrary Loads: YES
  - Allow Local Networking: YES
- ✅ Location When In Use Usage Description 있음

### 5. 실행!

#### 시뮬레이터
- `localhost:8080` 자동 사용
- Cmd + R 실행

#### 실제 기기
- AppConfig.swift에 IP가 `192.168.0.255`로 설정됨
- 기기와 맥북이 **같은 WiFi** 연결 필수
- Cmd + R 실행

## ✨ 주요 기능

### 🔍 검색 기능
- ✅ 현재 위치 기반 검색
- ✅ 반경 선택 (500m, 1km, 2km, 5km)
- ✅ 시간대별 영업 중인 카페 필터링
- ✅ 실시간 검색

### 🗺️ 지도 기능
- ✅ 카페 마커 표시
- ✅ 현재 위치로 이동
- ✅ 지도에서 카페 선택

### 📋 카페 상세 정보
- ✅ 카페 이름 및 주소
- ✅ **영업 상태 표시** (🟢 영업중 / 🔴 영업종료)
- ✅ **요일별 운영시간** (오늘 하이라이트)
- ✅ 지도 미리보기
- ✅ 길찾기 연동

### 🎨 UI/UX 개선
- ✅ 로딩 상태 표시
- ✅ 상세한 에러 메시지
- ✅ 위치 권한 안내
- ✅ 검색 결과 없음 안내

## 🐛 문제 해결

### "네트워크 오류"가 나는 경우

#### 1. 백엔드 서버 확인
```bash
# 브라우저에서 테스트
http://localhost:8080/health

# 또는
http://192.168.0.255:8080/health

# 결과: {"status":"UP"}
```

#### 2. WiFi 확인
- 맥북과 iOS 기기가 **같은 WiFi**에 연결되어 있나요?
- 시뮬레이터는 자동으로 localhost 사용

#### 3. IP 주소 확인
AppConfig.swift에서 IP가 올바른지 확인:
```swift
static let baseURL = "http://192.168.0.255:8080/api/v1"
```

#### 4. 방화벽 확인
맥북의 방화벽이 8080 포트를 차단하지 않는지 확인

### "위치 권한 거부"

설정 → 지금영업중 → 위치 → "앱 사용 중" 선택

### "앱이 크래시"

Xcode 콘솔에서 에러 로그 확인:
```
View → Debug Area → Activate Console
```

## 📊 API 엔드포인트

### 검색 API
```
GET /api/v1/cafes/search?lat={위도}&lng={경도}&radius={반경}&time={시간}

Response:
{
  "success": true,
  "data": {
    "content": [...],
    "totalElements": 10
  }
}
```

### 상세 조회 API
```
GET /api/v1/cafes/{cafeId}

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "name": "스타벅스",
    "operatingHours": [...]
  }
}
```

## 🎯 다음 단계 (출시 전 체크리스트)

- [ ] 실제 기기에서 테스트
- [ ] 앱 아이콘 추가
- [ ] 스플래시 스크린 추가
- [ ] 에러 로깅 개선
- [ ] 배포용 서버 URL 설정
- [ ] App Store Connect 설정

## 📞 문제가 있나요?

Xcode 콘솔에서 이런 로그가 보이는지 확인:
```
=== App Configuration ===
Environment: Simulator
Base URL: http://localhost:8080/api/v1
========================
```

검색 시:
```
🔍 검색 시작...
📍 위치: 37.4979, 127.0276
⏰ 시간: 14:30
📏 반경: 1000m
📡 API Request: http://...
📡 Response Status: 200
✅ 10개 카페 검색 완료
```

에러 발생 시:
```
❌ 네트워크 오류: ...
```

---

**행복한 개발 되세요! 🎉**
