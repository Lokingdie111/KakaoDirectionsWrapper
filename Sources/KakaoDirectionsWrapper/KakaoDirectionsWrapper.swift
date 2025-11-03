// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// 카카오 길찾기 API로 요청을 보내는 객체
///
/// 객체 생성시 카카오 디벨로퍼스에서 발급받은 REST API KEY를 전달해주어야 합니다. \
/// 카카오디벨로퍼스 주소: https://developers.kakao.com \
/// 위 사이트에서 키를 발급받아 주십시오.
public class DirectionAPI {
    private let apiKey: String
    
    /// 단일 출발지, 단일 목적지 길찾기 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - origin: 출발지 정보
    ///     - destination: 목적지 정보
    ///     - wayPoints: 경유지 정보. (최대 5개)
    ///     - priority: 경로 탐색 우선순위
    ///     - avoid: 경로 탐색 제한
    ///     - roadEvent: 도로 통제 정보 반영 옵션
    ///     - alternatives: 대안 경로 제공 여부
    ///     - roadDetails: 상세 도로 제공 여부
    ///     - carType: 차종 정보
    ///     - carFuel: 차량 유종 정보
    ///     - carHipass: 하이패스 장착 여부
    ///     - summary: 요약 정보만 받을지 여부
    /// - Returns: 요청 결과와 HTTP 상태코드를 튜플로 반환합니다. 상태코드가 200일때만 결과를 함께 반환합니다.
    /// - Throws: URL생성이나 JSON파싱 또는 응답수신에 문제가 있을경우 KakaoDirectionsError.internalError 를 반환합니다.
    public func request(origin: Position,
                        destination: Position,
                        wayPoints: [Position]? = nil,
                        priority: PriorityOption = .recommend,
                        avoid: [AvoidOption]? = nil,
                        roadEvent: RoadEventOption = .applyAll,
                        alternatives: Bool = false,
                        roadDetails: Bool = false,
                        carType: CarType = .small,
                        carFuel: CarFuelType = .gasoline,
                        carHipass: Bool = false,
                        summary: Bool = false,
    ) async throws -> (result: DirectionResponse?, statusCode: Int) {
        var address = "https://apis-navi.kakaomobility.com/v1/directions?"
        // Add origin info
        address.append("origin=\(origin.x),\(origin.y)\(origin.name != nil ? ",name=\(origin.name!)" : "")")
        address.append("&")
        // Add destination info
        address.append("destination=\(destination.x),\(destination.y)\(destination.name != nil ? ",name=\(destination.name!)" : "")")
        address.append("&")
        // Add waypoints info
        if let wayPoints = wayPoints {
            if wayPoints.count != 0 {
                address.append("waypoints=")
                for wayPoint in wayPoints {
                    address.append("\(wayPoint.x),\(wayPoint.y)\(wayPoint.name != nil ? ",name=\(wayPoint.name!)" : "")")
                    address.append("|")
                }
                // Remove last "|"
                _ = address.popLast()
                address.append("&")
            }
        }
        // Add priority info
        address.append("priority=\(priority.rawValue)")
        address.append("&")
        
        // Add avoid info
        if let avoid = avoid {
            if avoid.count != 0 {
                address.append("avoid=")
                for a in avoid {
                    address.append("\(a.rawValue)")
                    address.append("|")
                }
                _ = address.popLast()
                address.append("&")
            }
        }
        // Add raod event
        address.append("roadevent=\(roadEvent.rawValue)")
        address.append("&")
        // Add Alternatives
        address.append("alternatives=\(alternatives)")
        address.append("&")
        // Add road details
        address.append("road_details=\(roadDetails)")
        address.append("&")
        // Add car type
        address.append("car_type=\(carType.rawValue)")
        address.append("&")
        // Add car fuel
        address.append("car_fuel=\(carFuel.rawValue)")
        address.append("&")
        // Add car hipass
        address.append("car_hipass=\(carHipass)")
        address.append("&")
        address.append("summary=\(summary)")
        
        let url = URL(string: address)
        guard let url = url else {
            throw DirectionError.internalError
        }
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET"
        urlReq.setValue("KakaoAK \(self.apiKey)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, _response) = try await URLSession.shared.data(for: urlReq)
            let response = _response as! HTTPURLResponse
            
            guard response.statusCode == 200 else {
                return (nil, response.statusCode)
            }
            
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let json = json else {
                print("Failed to parse to json")
                throw DirectionError.internalError
            }
            
            let result = DirectionResponse(json)
            return (result, response.statusCode)
        } catch {
            print("Failed to recive data from server. \(error)")
            throw DirectionError.internalError
        }
    }
    
    /// 다중 경유지 요청을 보냅니다.
    ///
    /// - Parameters:
    ///     - origin: 출발지 정보
    ///     - destination: 목적지 정보
    ///     - wayPoints: 경유지 정보. (최대 5개)
    ///     - priority: 경로 탐색 우선순위
    ///     - avoid: 경로 탐색 제한
    ///     - roadEvent: 도로 통제 정보 반영 옵션
    ///     - alternatives: 대안 경로 제공 여부
    ///     - roadDetails: 상세 도로 제공 여부
    ///     - carType: 차종 정보
    ///     - carFuel: 차량 유종 정보
    ///     - carHipass: 하이패스 장착 여부
    ///     - summary: 요약 정보만 받을지 여부
    /// - Returns: 요청 결과와 HTTP 상태코드를 튜플로 반환합니다. 상태코드가 200일때만 결과를 함께 반환합니다.
    /// - Throws: URL생성이나 JSON파싱 또는 응답수신에 문제가 있을경우 KakaoDirectionsError.internalError 를 반환합니다.
    public func requestMultiWaypoints(origin: Position,
                        destination: Position,
                        wayPoints: [Position]? = nil,
                        priority: PriorityOption = .recommend,
                        avoid: [AvoidOption]? = nil,
                        roadEvent: RoadEventOption = .applyAll,
                        alternatives: Bool = false,
                        roadDetails: Bool = false,
                        carType: CarType = .small,
                        carFuel: CarFuelType = .gasoline,
                        carHipass: Bool = false,
                        summary: Bool = false,
    ) async throws -> (result: DirectionResponse?, statusCode: Int) {
        let url = URL(string: "https://apis-navi.kakaomobility.com/v1/waypoints/directions")
        guard let url = url else {
            print("[DirectionAPI] Failed to create URL...")
            throw DirectionError.internalError
        }
        var urlReq = URLRequest(url: url)
        var rawBody: [String: Any] = [:]
        rawBody["origin"] = origin.rawValue
        rawBody["destination"] = destination.rawValue
        if let wayPoints = wayPoints {
            rawBody["waypoints"] = wayPoints.map({ item in
                return item.rawValue
            })
        }
        rawBody["priority"] = priority.rawValue
        if let avoid = avoid {
            rawBody["avoid"] = avoid.map({ item in
                item.rawValue
            })
        }
        rawBody["roadevent"] = roadEvent.rawValue
        rawBody["alternatives"] = alternatives
        rawBody["road_details"] = roadDetails
        rawBody["car_type"] = carType.rawValue
        rawBody["car_fuel"] = carFuel.rawValue
        rawBody["car_hipass"] = carHipass
        rawBody["summary"] = summary
        guard let bodyData = try? JSONSerialization.data(withJSONObject: rawBody) else {
            print("[DirectionAPI] Failed to convert body to Data")
            throw DirectionError.internalError
        }
        urlReq.httpBody = bodyData
        urlReq.setValue("KakaoAK \(self.apiKey)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.httpMethod = "POST"
        
        do {
            let (_data, response) = try await URLSession.shared.data(for: urlReq)
            let res = response as! HTTPURLResponse
            if res.statusCode != 200 {
                print("[DirectionAPI] HTTP status code is not 200. return nil.")
                return (nil, res.statusCode)
            }
            let data = try? JSONSerialization.jsonObject(with: _data) as? [String: Any]
            guard let data = data else {
                print("[DirectionAPI] Failed to decode data.")
                throw DirectionError.internalError
            }
            let result = DirectionResponse(data)
            return (result, res.statusCode)
        } catch {
            print("[DirectionAPI] Failed to get response from server.")
            throw DirectionError.internalError
        }
    }
    /// 다중 출발지, 단일 목적지
    ///
    /// - Warning: priority .recommend 사용불가
    ///
    /// - Parameters:
    ///     - origin: 출발지 배열
    ///     - destination: 목적지
    ///     - radius: 길찾기 반경(미터)(최대: 10000)
    ///     - priority: 경로 탐색 우선순위 (.recommend 사용불가)
    ///     - avoid: 경로 탐색 제한 옵션
    ///     - roadEvent: 도로 통제 정보 반영 옵션
    ///
    /// - Returns: 요청 결과와 HTTP 상태코드를 튜플로 반환합니다. 상태코드가 200일때만 결과를 함께 반환합니다.
    /// - Throws: URL생성이나 JSON파싱 또는 응답수신에 문제가 있을경우 KakaoDirectionsError.internalError 를 반환합니다.
    
    public func requestMultiOrigin(origins: [PositionWithKey],
                                   destination: Position,
                                   radius: Int,
                                   priority: PriorityOption = .time,
                                   avoid: [AvoidOption]? = nil,
                                   roadEvent: RoadEventOption = .applyAll
    ) async throws -> (result: MultiDirectionResponse?, statusCode: Int) {
        if priority == .recommend {
            print("[DirectionAPI] Cannot use priority .recommend in requstMultiOrigin!")
            throw DirectionError.internalError
        }
        let url = URL(string: "https://apis-navi.kakaomobility.com/v1/origins/directions")
        guard let url = url else {
            print("[DirectionAPI] Failed to create URL.")
            throw DirectionError.internalError
        }
        var urlReq = URLRequest(url: url)
        // Set method
        urlReq.httpMethod = "POST"
        // Set auth key
        urlReq.setValue("KakaoAK \(self.apiKey)", forHTTPHeaderField: "Authorization")
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Create Body
        var rawBody: [String: Any] = [:]
        rawBody["origins"] = origins.map({ item in
            return item.rawValue
        })
        rawBody["destination"] = destination.rawValue
        rawBody["radius"] = radius
        rawBody["priority"] = priority.rawValue
        
        if let avoid = avoid {
            if avoid.count != 0 {
                rawBody["avoid"] = avoid.map({ item in
                    item.rawValue
                })
            }
        }
        rawBody["roadevent"] = roadEvent.rawValue
        let body = try? JSONSerialization.data(withJSONObject: rawBody)
        guard let body = body else {
            print("[DirectionAPI] Failed to create http body Data")
            throw DirectionError.internalError
        }
        
        urlReq.httpBody = body
        
        do {
            let (_data, response) = try await URLSession.shared.data(for: urlReq)
            let code = (response as! HTTPURLResponse).statusCode
            if code != 200 {
                return (nil, code)
            }
            let data = try? JSONSerialization.jsonObject(with: _data) as? [String: Any]
            guard let data = data else {
                print("[DirectionAPI] Failed to convert json data")
                throw DirectionError.internalError
            }
            return (MultiDirectionResponse(data), code)
        } catch {
            print("[DirectionAPI] Failed to get response from API server.")
            throw DirectionError.internalError
        }
    }
    
    /// - Parameters:
    ///     - apiKey: 카카오디벨로퍼스에서 발급 받은 API키 값 (REST API Key 값)
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}

/// 위치를 저장하는 구조체
///
/// - Parameters:
///     - name: 이름
///     - x: X좌표(경도)
///     - y: Y좌표(위도)
public struct Position {
    /// 이름
    public let name: String?
    /// X좌표(경도)
    public let x: Double
    /// Y좌표(위도)
    public let y: Double
    
    /// 위도(Y좌표)
    public var latitude: Double {
        return y
    }
    
    /// 경도(X좌표)
    public var longtidue: Double {
        return x
    }
    
    /// key-value로 표현한 dict
    var rawValue: [String: Any] {
        get {
            if let name = name {
                return ["x" : x, "y" : y, "name" : name]
            } else {
                return ["x" : x, "y" : y]
            }
        }
    }
    
    public init(name: String? = nil, x: Double, y: Double) {
        self.name = name
        self.x = x
        self.y = y
    }
    public init(name: String? = nil, longitude: Double, latitude: Double) {
        self.name = name
        self.x = longitude
        self.y = latitude
    }
}

/// 경로 탐색 우선순위를 표현하는 열거형
public enum PriorityOption: String {
    /// 추천 경로
    case recommend = "RECOMMEND"
    /// 최단 시간
    case time = "TIME"
    /// 최단 경로
    case distance = "DISTANCE"

}

/// 경로 탐색 제한 옵션을 표현하는 열거형
public enum AvoidOption: String {
    /// 페리 항로
    case ferries = "ferries"
    /// 유료 도로
    case toll = "toll"
    /// 자동차 전용 도로
    case motorway = "motorway"
    /// 어린이 보호 구역
    case schoolzone = "schoolzone"
    /// 유턴
    case uturn = "uturn"
}

/// 차량 통제 반영 여부를 나타내는 열거형
public enum RoadEventOption: Int {
    /// 전체 차선 통제 정보 반영
    case applyAll = 0
    /// 출발지 및 목적지 주변의 전체 차선 통제 정보 반영 안함
    case notApplyNear = 1
    /// 모든 구간의 전체 차선 통제 정보 반영 안함
    case notApplyAll = 2
}

/// 차종을 표현하는 열거형
public enum CarType: Int {
    /// 소형
    case small = 1
    /// 중형
    case medium = 2
    /// 대형
    case large = 3
    /// 대형 화물
    case largeCargo = 4
    /// 특수 화물
    case specialCargo = 5
    /// 경차
    case compact = 6
    /// 이륜차
    case twoWheel = 7
}

/// 차량 유종을 표현하는 열거형
public enum CarFuelType: String {
    /// 휘발유
    case gasoline = "GASOLINE"
    /// 경유
    case diesel = "DIESEL"
    /// LPG
    case lpg = "LPG"
}
