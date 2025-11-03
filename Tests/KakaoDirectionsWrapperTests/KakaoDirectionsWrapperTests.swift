import Testing
import Foundation
@testable import KakaoDirectionsWrapper



@Test func request() async throws {
    
    let origin: Position = Position(name: "출발지", longitude: 126.97815420, latitude: 37.5668601514026) // 서울 시청
    let destination: Position = Position(name: "목적지",longitude: 126.979864052, latitude: 37.5643917261) // 주변 호텔
    let waypoint1 = Position(name: "경유지", longitude: 126.9764161, latitude: 37.568598)
    let directionAPI = DirectionAPI(apiKey: "")
    let result = try? await directionAPI.request(origin: origin, destination: destination, wayPoints: [waypoint1])
    #expect(result != nil)
}

@Test func requestMultiWaypoints() async throws {
    let origin: Position = Position(name: "서울 시청", longitude: 126.97815420, latitude: 37.5668601514026)
    let destination: Position = Position(name: "웨스턴 조선 서울",longitude: 126.979864052, latitude: 37.5643917261)
    
    let waypoint1 = Position(name: "경유지1", longitude: 126.9764161, latitude: 37.568598)
    let waypoint2 = Position(name: "경유지2", longitude: 126.98414660, latitude: 37.571798563)
    let waypoint3 = Position(name: "경유지3", longitude: 126.9774161, latitude: 37.568598)
    let waypoint4 = Position(name: "경유지4", longitude: 126.98414660, latitude: 37.571798563)
    let waypoint5 = Position(name: "경유지5", longitude: 126.9784161, latitude: 37.568598)
    let waypoint6 = Position(name: "경유지6", longitude: 126.98414660, latitude: 37.571798563)
    
    let directionAPI = DirectionAPI(apiKey: "")
    
    let result = try? await directionAPI.requestMultiWaypoints(origin: origin, destination: destination, wayPoints: [waypoint1, waypoint2, waypoint3, waypoint4, waypoint5, waypoint6])
    #expect(result != nil)
    
}

@Test func reqeustMultiOrigin() async throws {
    
}

@Test func requestMultiDestination() async throws {
    
}
