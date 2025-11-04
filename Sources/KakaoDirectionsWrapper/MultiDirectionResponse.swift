//
//  MultiDirectionResponse.swift
//  KakaoDirectionsWrapper
//
//  Created by 민현규 on 11/3/25.
//

public struct MultiDirectionResponse {
    /// 경로 요청 ID
    public let trans_id: String
    public let routes: [Route]
    
    init(_ res: [String: Any]) {
        self.trans_id = res["trans_id"] as! String
        self.routes = (res["routes"] as! [[String: Any]]).map({ item in
            return Route(item)
        })
    }
}

public extension MultiDirectionResponse {
    /// 경로 정보, 경로 수만큼 생성
    struct Route {
        /// 경로 탐색 결과 코드
        let result_code: Int
        /// 경로 탐색 결과 메시지
        let result_msg: String
        /// origins의 key 값으로 지정한 각 출발지의 키 값
        let key: String
        /// 경로 요약 정보
        let summary: Summary
        
        init(_ routeObj: [String: Any]) {
            self.result_code = routeObj["result_code"] as! Int
            self.result_msg = routeObj["result_msg"] as! String
            self.key = routeObj["key"] as! String
            self.summary = Summary(routeObj["summary"] as! [String: Any])
        }
    }
    
    struct Summary {
        /// 전체 검색 결과 거리(미터)
        let distance: Int
        /// 목적지까지 소요 시간(초)
        let duration: Int
        init(_ summaryObj: [String: Any]) {
            self.distance = summaryObj["distance"] as! Int
            self.duration = summaryObj["duration"] as! Int
        }
    }
}
public struct PositionWithKey {
    /// X좌표(경도)
    public let x: Double
    /// Y좌표(위도)
    public let y: Double
    /// 각 위치를 구분하기 위한 문자열
    public let key: String
    
    internal var rawValue: [String: Any] {
        get {
            return ["x" : x, "y" : y, "key" : key]
        }
    }
    
    /// 위도(Y좌표)
    public var latitude: Double {
        get {
            return y
        }
    }
    
    /// 경도(X좌표)
    public var longitude: Double {
        get {
            return x
        }
    }
    
    public init(key: String, x: Double, y: Double) {
        self.x = x
        self.y = y
        self.key = key
    }
    
    public init(key: String, longitude: Double, latitude: Double) {
        self.x = longitude
        self.y = latitude
        self.key = key
    }
}
