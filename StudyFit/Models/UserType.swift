//
//  UserType.swift
//  StudyFit
//
//
//

import Foundation

struct StudyResult: Codable{
    let personalityType: StudyPersonalityType
    let score: [String: Int]
    let recommendations: [String]
    let timestamp: Date
    
    // 사용자 친화적인 날짜 표시
    var displayDate: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: timestamp)
    }
    
    // 며칠 전인지 표시
    var timeAgo: String{
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(timestamp){
            return "오늘"
        }else if calendar.isDateInYesterday(timestamp){
            return "어제"
        }else{
            let days = calendar.dateComponents([.day], from: timestamp, to: now).day ?? 0
            return "\(days)일 전"
        }
    }
}

enum StudyPersonalityType: String, CaseIterable, Identifiable, Codable{
    case examFocused = "exam_focused" // 시험형
    case conceptMaster = "concept_master" // 개념형
    case problemSolver = "problem_solver" // 문제형
    case steady = "steady" // 꾸준형
    case intensive = "intensive" // 집중형
    
    var id: String{self.rawValue}
    
    var displayName: String{
        switch self{
        case .examFocused: return "시험형"
        case .conceptMaster: return "개념형"
        case .problemSolver: return "문제형"
        case .steady: return "꾸준형"
        case .intensive: return "집중형"
        }
    }
    
    // 각 유형별 특징 설명
    var description: String{
        switch self{
        case .examFocused:
            return "내신과 수능에 최적화된 효율적 학습을 선호합니다. 기출문제 분석과 출제 경향 파악에 뛰어나며, 시험에서 좋은 결과를 얻는 것을 최우선으로 합니다."
        case .conceptMaster:
            return "개념을 완전히 이해하고 체계적으로 학습하는 것을 중시합니다. 근본 원리를 파악하며 기르는 것을 선호하며, 깊이 있는 학습을 추구합니다."
        case .problemSolver:
            return "다양한 문제를 통해 실전 감각을 기르는 것을 선호합니다. 많은 문제 풀이 경험을 바탕으로 빠른 문제 해결 능력을 기르는 데 집중합니다."
        case .steady:
            return "꾸준하고 안정적인 학습 패턴을 유지합니다. 장기적인 계획을 세우고 매일 일정한 양의 공부를 하며, 규칙적인 생활을 통해 성과를 냅니다."
        case .intensive:
            return "짧은 시간에 집중적으로 몰입하여 효과를 극대화합니다. 컨디션과 상황에 따라 유연하게 학습하며, 집중력이 높으 ㄹ때 최대한 활용합니다."
        }
    }
    
    // 각 유형별 추천 학습법
    var studyMethods: [String]{
        switch self{
        case .examFocused:
            return [
                "기출문제 중심 학습",
                "출제 경향 분석",
                "시간 분배 연습",
                "실전 모의고사",
                "유형별 문제 정리"
            ]
        case .conceptMaster:
            return [
                "개념서 정독",
                "원리 이해 중심 학습",
                "개념 맵 작성",
                "설명하며 학습",
                "심화 문제 도전"
            ]
        case .problemSolver:
            return [
                "문제집 다량 풀이",
                "유형별 문제 분류",
                "오답 노트 정리",
                "시간 단축 연습",
                "실전 감각 기르기"
            ]
        case .steady:
            return [
                "매일 일정 분량 학습",
                "장기 계획 수립",
                "규칙적인 복습",
                "진도 체크리스트",
                "꾸준한 습관 형성"
            ]
        case .intensive:
            return [
                "집중 시간대 활용",
                "몰입 환경 조성",
                "단기 목표 설정",
                "컨디션 관리",
                "효율적 학습법"
            ]
        }
    }
    
    // 각 유형별 추천 시간대
    var recommendedStudyTime: String {
        switch self{
        case .examFocused:
            return "시험 일정에 맞춘 계획적 시간 분배"
        case .conceptMaster:
            return "충분한 시간을 확보할 수 있는 주말이나 긴 시간"
        case .problemSolver:
            return "매일 일정 시간 문제 풀이 시간 확보"
        case .steady:
            return "매일 같은 시간대에 규칙적으로"
        case .intensive:
            return "컨디션이 좋을 때 집중적으로"
        }
    }
}

// 점수 계산을 위한 헬퍼 함수들
extension StudyResult{
    // 가장 높은 점수의 성향 타입 반환
    static func calculatePersonalityType(from scores: [String:Int]) -> StudyPersonalityType{
        let maxScore = scores.values.max() ?? 0
        let topTypes = scores.filter{$0.value == maxScore}
        
        // 동점일 경우 우선순위 적용(균형잡힌 학습자는 꾸준형으로)
        let priorityOrder: [StudyPersonalityType] = [
            .steady, .conceptMaster, .examFocused, .problemSolver, .intensive
        ]
        
        for type in priorityOrder{
            if topTypes.keys.contains(type.rawValue){
                return type
            }
        }
        
        return .steady //기본값
    }
}
