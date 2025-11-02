# KakaoDirectionsWrapper

카카오 길찾기 API로 요청을 보내어 그 결과를 받습니다.

## 카카오 길찾기 API 키
이 Wrapper를 통해 길찾기 요청을 보내기 위해서는 카카오디벨로퍼스에서 API 키를 발급받아 사용해야합니다.
- 카카오 디벨로퍼스 홈페이지: https://developers.kakao.com

### 주의사항
해당 키를 프로젝트 코드에 평문으로 저장하지 마십시오. 키가 타인에게 노출될 위험이 있습니다. \
info.plist와 같은 곳에 저장후 .gitignore등에 해당 파일을 깃허브에 푸시하지 않도록 설정하십시오.

## DirectionAPI
이 클래스를 통해 요청을 보내어 응답결과를 받습니다.

### 단일 출발지, 단일 목적지
단일 출발지와 단일 목적지를 기준으로 길찾기 정보를 요청할때 사용합니다. 경유지 최대 5개
```swift
    let directionAPI = DirectionAPI()
    Task {
        do {
            let (result, code) = directionAPI.request(origin: Location(x: <출발지 x좌표>,y: <출발지 y좌표>), destination: Location(x: <목적지 x좌표>,y: <목적지 y좌표>))
        } catch {
            print("Failed to get response from server.")
        }
    }
```
#### Location 구조체
특정 지점의 위치와 이름을 저장하기 위한 구조체
1. name: String?
    - 해당 위치의 이름을 지정합니다. 기본값 nil
2. x: Double
    - 해당 위치의 x좌표(경도)를 저장합니다.
3. y: Double
    - 해당 위치의 y좌표(위도)를 저장합니다.
4. longitude, latitude
    - foo.x == foo.longitude
    - foo.y == foo.latitude

