# KakaoDirectionsWrapper

카카오 길찾기 API로 요청을 보내고 응답을 사용하기 편리하게 하기 위한 Wrapper.
## 설치 
Xcode의 SPM을 통해 프로젝트에 패키지를 추가할수 있습니다. \
Repo 주소. `https://github.com/Lokingdie111/KakaoDirectionsWrapper.git` 
### 카카오 길찾기 API 키
이 Wrapper를 통해 길찾기 요청을 보내기 위해서는 카카오디벨로퍼스에서 API 키를 발급받아 사용해야합니다.
- 카카오 디벨로퍼스 홈페이지: `https://developers.kakao.com`

## DirectionAPI
카카오 길찾기 API로 요청을 보내어 응답결과를 받습니다.
- **네트워크 연결 상태는 내부적으로 검사하지 않습니다.** 
### 단일 출발지, 단일 목적지 - request()
단일 출발지와 단일 목적지를 기준으로 길찾기 정보를 요청할때 사용합니다. \
경유지는 최대 5개, 경로의 총 길이는 1500km를 넘지 않아야합니다.
|함수인자|설명|타입
|-----|---|--|
|origin|출발지 정보 (**필수**)|Position|
|destination|목적지 정보 (**필수**)|Position|
|wayPoints|경유지 정보 배열 (기본값 nil)|[Position]?|
|priority|경로 탐색 우선순위 (기본값 .recommend)|PriorityOption|
|avoid|경로 탐색 제한 (기본값 nil)|[AvoidOption]?|
|roadEvent|도로 통제 정보 반영 옵션 (기본값 .applyAll)|RoadEventOption|
|alternatives|대안 경로 제공 여부 (기본값 false)|Bool|
|roadDetails|상세 도로 제공 여부 (기본값 false)|Bool|
|carType|차종 정보 (기본값 .small)|CarType|
|carFuel|차량 유종 정보 (기본값 .gasoline)|CarFuelType|
|carHipass|하이패스 장착 여부 (기본값 false)|Bool|
|summary|요약 정보만 받을지 여부 (기본값 false)|Bool|
#### 예제
```swift
let directionAPI = DirectionAPI()

Task {
    do {
        let originLocation = Location(x: 126.97,y: 37.57)
        let destinationLocation = Location(x: 126.91,y: 37.52)
        let (result, code) = try await directionAPI.request(origin: originLocation, destination: destinationLocation)
    } catch {
        print("Failed to get response from server.")
    }
}
```

### 단일 출발지, 단일 목적지, 다중 경유지 - requestMultiWaypoints()
경유지를 최대 30개까지 사용할수 있습니다. (추후 업데이트 예정)

### 단일 출발지, 다중 목적지 - requestMultiDestiation()
여러 목적지로까지의 경로 정보를 요약 정보로 받아올수 있습니다. (추후 업데이트 예정)

### 다중 출발지, 단일 목적지 - requestMultiOrigin()
여러 출발지에서 한 목적지로까지의 경로 정보를 요약 정보로 받아올수 있습니다. (추후 업데이트 예정)
