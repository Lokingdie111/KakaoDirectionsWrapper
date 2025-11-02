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
