//
//  KakaoDirectionsResult.swift
//  KakaoDirectionsAPI
//
//  Created by 민현규 on 11/2/25.
//


/// 카카오 길찾기 API로부터 온 응답을 저장하는 구조체
///
/// - Date: 이 도큐먼트는 2025/12/2 에 작성되었습니다.
///
/// 카카오 길찾기API에서 응답한 JSON데이터를 구조체로 저장하기 위한 구조체입니다.
/// API에서 온 JSON을 [String: Any] 타입으로 캐스팅하여 init() 함수에 전달해주십시오.
/// 상세한 프로퍼티의 정보는 카카오 길찾기API Document에서 확인하십시오. https://developers.kakaomobility.com/docs/navi-api/start/
public struct DirectionResponse {
    /// 경로 요청 ID
    let trans_id: String
    /// 경로 정보
    ///
    /// alternatives가 true인 경우 한 개 이상의 경로 제공 가능
    let routes: [Route]
    init(_ res: [String: Any]) {
        self.trans_id = res["trans_id"] as! String
        let routesObj = res["routes"] as! [[String: Any]]
        var routes: [Route] = []
        for routeObj in routesObj {
            routes.append(Route(routeObj))
        }
        self.routes = routes
    }
    
    struct Route {
        /// 경로 탐색 결과 코드
        let result_code: Int
        /// 경로 탐색 결과 메시지
        let result_msg: String
        /// 경로 요약 정보
        let summary: Summary
        
        /// 구간별 경로 정보
        ///
        /// 경유지가 존재할 경우 {경유지 수 + 1} 만큼의 섹션(경로 구간) 생성
        /// - 예 : 경유지 수가 2개인 경우 총 3개의 섹션 정보가 생성
        ///     - section1: 출발지 -> 경유지 1
        ///     - section2: 경유지 1 -> 경유지 2
        ///     - section3: 경유지 2 -> 목적지
        let sections: [Section]
        
        init(_ routeObj: [String: Any]) {
            self.result_code = routeObj["result_code"] as! Int
            self.result_msg = routeObj["result_msg"] as! String
            let summaryObj = routeObj["summary"] as! [String: Any]
            self.summary = Summary(summaryObj)
            let sectionsObj = routeObj["sections"] as! [[String: Any]]
            var sections:[Section] = []
            for sectionObj in sectionsObj {
                sections.append(Section(sectionObj))
            }
            self.sections = sections
        }

    }
}

extension DirectionResponse {
    struct Fare {
        /// 택시 요금 (원)
        let taxi: Int
        /// 통행 요금 (원)
        let toll: Int
        init(_ obj: [String: Int]) {
            self.taxi = obj["taxi"]!
            self.toll = obj["toll"]!
        }
    }
    struct Summary {
        /// 출발지 정보
        let origin: Point
        /// 목적지 정보
        let destination: Point
        /// 경유지 정보
        let wayPoints: [Point]
        /// 경로 탐색 우선순위 옵션
        let priority: String
        
        /// 모든 경로를 포함하는 사각형의 바운딩 박스 (Bounding box)
        let bound: Bound?
        /// 요금 정보
        let fare: Fare
        /// 전체 검색 결과 거리 (미터)
        let distance: Int
        /// 목적지까지 소요 시간(초)
        let duration: Int
        
        init(_ summaryObj: [String: Any]) {
            let origin = summaryObj["origin"] as! [String: Any]
            self.origin = Point(origin)
            let destination = summaryObj["destination"] as! [String: Any]
            self.destination = Point(destination)
            let _waypoints = summaryObj["waypoints"] as! [[String: Any]]
            var wayPoints: [Point] = []
            for waypoint in _waypoints {
                wayPoints.append(Point(waypoint))
            }
            self.wayPoints = wayPoints
            let priority = summaryObj["priority"] as! String
            self.priority = priority
            let bound = summaryObj["bound"] as? [String: Double]
            if let bound = bound {
                self.bound = Bound(bound)
            } else {
                self.bound = nil
            }
            
            let fare = summaryObj["fare"] as! [String: Int]
            self.fare = Fare(fare)
            let distance = summaryObj["distance"] as! Int
            self.distance = distance
            let duration = summaryObj["duration"] as! Int
            self.duration = duration
        }
    }
    struct Section {
        /// 색션 거리 (미터)
        let distance: Int
        /// 전체 검색 결과 이동시간 (초)
        let duration: Int
        /// 모든 경로를 포함하는 사각형의 바운딩 박스
        ///
        /// summary가 false인 경우에만 제공
        let bound: Bound?
        /// 도로 정보
        ///
        /// summary가 false인 경우에만 제공
        let roads: [Road]?
        /// 안내 정보
        ///
        /// summary가 false인 경우에만 제공
        let guides: [Guide]?
        init(_ sectionObj: [String: Any]) {
            self.distance = sectionObj["distance"] as! Int
            self.duration = sectionObj["duration"] as! Int
            if let obj = sectionObj["bound"] as? [String: Double] {
                self.bound = Bound(obj)
            } else {
                self.bound = nil
            }
            let _roads = sectionObj["roads"] as? [[String: Any]]
            
            if let _roads = _roads {
                var roads: [Road] = []
                for road in _roads {
                    roads.append(Road(road))
                }
                self.roads = roads
            } else {
                self.roads = nil
            }
            let _guides = sectionObj["guides"] as? [[String: Any]]
            
            if let _guides = _guides {
                var guides: [Guide] = []
                for guide in _guides {
                    guides.append(Guide(guide))
                }
                self.guides = guides
            } else {
                self.guides = nil
            }
        }
    }
    struct Point {
        /// 이름
        let name: String
        /// X좌표(경도)
        let x: Double
        /// Y좌표(위도)
        let y: Double
        init(_ obj: [String: Any]) {
            self.name = obj["name"] as! String
            self.x = obj["x"] as! Double
            self.y = obj["y"] as! Double
        }
    }
    
    struct Bound {
        /// 박스 좌하단 X좌표
        let min_x: Double
        /// 박스 좌하단 y좌표
        let min_y: Double
        /// 박스 우상단 x좌표
        let max_x: Double
        /// 박스 우상단 y좌표
        let max_y: Double
        
        init(_ obj: [String: Double]) {
            self.min_x = obj["min_x"]!
            self.min_y = obj["min_y"]!
            self.max_x = obj["max_x"]!
            self.max_y = obj["max_y"]!
        }
    }
    struct Road {
        /// 도로명
        let name: String
        /// 도로 길이(미터)
        let distance: Int
        /// 예상 이동 시간(초)
        let duration: Int
        /// 현재 교통 정보 속도(km/h)
        let traffic_speed: Double
        /// 현재 교통 정보 상태
        let traffic_state: Int
        /// X,Y 좌표로 구성된 1차원 배열
        let vertexes: [Double]
        
        init(_ roadObj: [String: Any]) {
            self.name = roadObj["name"] as! String
            self.distance = roadObj["distance"] as! Int
            self.duration = roadObj["duration"] as! Int
            self.traffic_speed = roadObj["traffic_speed"] as! Double
            self.traffic_state = roadObj["traffic_state"] as! Int
            self.vertexes = roadObj["vertexes"] as! [Double]
        }
    }
    struct Guide {
        /// 명칭
        let name: String
        /// X좌표(경도)
        let x: Double
        /// Y좌표(위도)
        let y: Double
        /// 이전 가이드 지점부터 현재 가이드 지점까지 거리(미터)
        let distance: Int
        /// 이전 가이드 지점부터 현재 가이드 지점까지 시간(초)
        let duration: Int
        /// 안내 타입
        let type: Int
        /// 안내 문구
        let guidance: String
        /// 현재 가이드에 대한 링크 인덱스
        let road_index: Int
        init(_ guideObj: [String: Any]) {
            self.name = guideObj["name"] as! String
            self.x = guideObj["x"] as! Double
            self.y = guideObj["y"] as! Double
            self.distance = guideObj["distance"] as! Int
            self.duration = guideObj["duration"] as! Int
            self.type = guideObj["type"] as! Int
            self.guidance = guideObj["guidance"] as! String
            self.road_index = guideObj["road_index"] as! Int
        }
    }
}
