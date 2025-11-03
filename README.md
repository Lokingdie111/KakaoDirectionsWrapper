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
|함수인자|설명|타입|
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
let directionAPI = DirectionAPI(apiKey: key)

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
- 경유지를 최대 30개까지 사용할수 있습니다. 그 이외의 것들을 단일 출발지, 단일 목적지와 같습니다.
#### 예제
```swift
    let origin: Position = Position(name: "서울 시청", longitude: 126.97815420, latitude: 37.5668601514026)
    let destination: Position = Position(name: "웨스턴 조선 서울",longitude: 126.979864052, latitude: 37.5643917261)
    
    let waypoint1 = Position(name: "경유지1", longitude: 126.9764161, latitude: 37.568598)
    let waypoint2 = Position(name: "경유지2", longitude: 126.98414660, latitude: 37.571798563)
    let waypoint3 = Position(name: "경유지3", longitude: 126.9774161, latitude: 37.568598)
    let waypoint4 = Position(name: "경유지4", longitude: 126.98414660, latitude: 37.571798563)
    let waypoint5 = Position(name: "경유지5", longitude: 126.9784161, latitude: 37.568598)
    let waypoint6 = Position(name: "경유지6", longitude: 126.98414660, latitude: 37.571798563)
    
    let directionAPI = DirectionAPI(apiKey: key)
    Task {
        do {
        let (result, code) = try await directionAPI.requestMultiWaypoints(origin: origin, destination: destination, wayPoints: [waypoint1, waypoint2, waypoint3, waypoint4, waypoint5, waypoint6])       
        } catch {
            print("Failed to get response from server.")
        }
    }

```
### 단일 출발지, 다중 목적지 - requestMultiDestiation()
단일 출발지와 다중 목적지로 길찾기를 요청합니다. \
자세한 길 정보는 반환하지 않습니다. 짧게 요약된 거리정보 예상 시간정보등만이 반환됩니다.
- priority에 .recommend는 사용할수 없습니다.

|함수인자|설명|타입|
|-----|---|--|
|origin|출발지 정보 (**필수**)|Position|
|destinations|목적지 배열 (**필수**)|[PositionWithKey]|
|radius|길찾기 반경(미터)(최대: 10000)(**필수**)|Int|
|priority|경로 탐색 우선순위 (기본값 .time)|PriorityOption|
|avoid|경로 탐색 제한 (기본값 nil)|[AvoidOption]?|
|roadEvent|도로 통제 정보 반영 옵션 (기본값 .applyAll)|RoadEventOption|
#### 예제
```swift
    let destination1: PositionWithKey = PositionWithKey(key: "출발지1", longitude: 126.97815420, latitude: 37.5668601514026)
    let destination2: PositionWithKey = PositionWithKey(key: "출발지2", longitude: 126.979864052, latitude: 37.5643917261)
    
    let origin = Position(name: "목적지", longitude: 126.9764161, latitude: 37.568598)
    
    let directionAPI = DirectionAPI(apiKey: key)
    Task {
        let result = try? await directionAPI.requestMultiDestination(origin: origin, destinations: [destination1, destination2], radius: 1000)   
    }

```
### 다중 출발지, 단일 목적지 - requestMultiOrigin()
다중 출발지와 단일 목적지로 길찾기를 요청합니다. \ 
자세한 길 정보는 반환하지 않습니다. 짧게 요약된 거리정보 예상 시간정보등만이 반환됩니다.
- priority에 .recommend는 사용할수 없습니다.

|함수인자|설명|타입|
|-----|---|--|
|origins|출발지 배열 (**필수**)|[PositionWithKey]|
|destination|목적지 (**필수**)|Position|
|radius|길찾기 반경(미터)(최대: 10000)(**필수**)|Int|
|priority|경로 탐색 우선순위 (기본값 .time)|PriorityOption|
|avoid|경로 탐색 제한 (기본값 nil)|[AvoidOption]?|
|roadEvent|도로 통제 정보 반영 옵션 (기본값 .applyAll)|RoadEventOption|
#### 예제
```swift
    let origin1: PositionWithKey = PositionWithKey(key: "출발지1", longitude: 126.97815420, latitude: 37.5668601514026)
    let origin2: PositionWithKey = PositionWithKey(key: "출발지2", longitude: 126.979864052, latitude: 37.5643917261)
    
    let destination = Position(name: "목적지", longitude: 126.9764161, latitude: 37.568598)
    
    let directionAPI = DirectionAPI(apiKey: key)
    Task {
        let result = try? await directionAPI.requestMultiOrigin(origins: [origin1, origin2], destination: destination, radius: 1000)   
    }

```
## DirectionResponse
request()와 requestMultiWaypoints()는 이 구조체로 반환됩니다. \
이 구조체는 API응답 결과를 담고있습니다. \
각각의 프로퍼티들의 의미는 Xcode의 Quick-help 또는 카카오 길찾기 API 도큐먼트에서 확인할수 있습니다.
[카카오 길찾기 API 바로가기](https://developers.kakaomobility.com/docs/navi-api)

## MultiDirectionResponse
requestMultiOrigin()과 requestMultiDestination()은 이 구조체로 반환됩니다. \
이 구조체는 API응답 결과를 담고있습니다. \
각각의 프로퍼티들의 의미는 Xcode의 Quick-help 또는 카카오 길찾기 API 도큐먼트에서 확인할수 있습니다. \
DirectionResponse와 비교해 이 구조체는 경로의 상세정보를 포함하지 않습니다.
[카카오 길찾기 API 바로가기](https://developers.kakaomobility.com/docs/navi-api)