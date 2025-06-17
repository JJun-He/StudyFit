//
//  SampleQuestions.swift
//  StudyFit
//
//
//

import Foundation

struct Question: Codable, Identifiable, Hashable{
    let id: Int
    let text: String
    let options: [String]
    let category: QuestionCategory
    let scoringMap: [String: [String: Int]]
    
    // Hashable 구현
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    static func == (lhs: Question, rhs: Question) -> Bool{
        return lhs.id == rhs.id
    }
}

enum QuestionCategory: String, Codable, CaseIterable{
    case studyTime = "study_time"
    case studyPattern = "study_pattern"
    case studyMethod = "study_method"
    case problemSolving = "problem_solving"
    case memorization = "memorization"
    case motivation = "motivation"
    case selfAnalysis = "self_analysis"
    case priority = "priority"
    case environment = "environment"
    case stressManagement = "stress_management"
    case planning = "planning"
    
    var displayName: String{
        switch self {
        case .studyTime: return "학습 시간"
        case .studyPattern: return "학습 패턴"
        case .studyMethod: return "학습 방식"
        case .problemSolving: return "문제 해결"
        case .memorization: return "암기 방법"
        case .selfAnalysis: return "자기 분석"
        case .priority: return "학습 우선순위"
        case .environment: return "학습 환경"
        case .stressManagement: return "스트레스 관리"
        case .planning: return "계획 수립"
        }
    }
}

let sampleQuestions = [
    // 학습 데이터
    Question(
        id: 1,
        text: "평소 공부할 때 가장 집중이 잘 되는 시간은?",
        options: [
            "등교 전 새벽(6~8시)",
            "오전 (08:00-12:00)",
            "오후 (12:00-18:00)",
            "저녁 (18:00-22:00)",
            "밤  (22:00-02:00)",
        ],
        category: .studyTime,
        scoringMap: [
            "새벽 (05:00-08:00)": ["systematic": 2, "goalOriented": 1],
            "오전 (08:00-12:00)": ["systematic": 1, "practical": 1],
            "저녁 (18:00-22:00)": ["social": 1, "creative": 1],
            "밤 (22:00-02:00)": ["creative": 2]
        ]
    ),
    
    // 학습 방식
    Question(id: 2,, text: "새로운 내용을 학습할 때 선호하는 방식은", options: ["개념을 완전히 이해한 후 문제풀이", "문제를 풀면서 개념을 익혀나가기", "요약 정리를 먼저 만들고 암기", "실제 사례나 응용 위주로 학습"],
        category: .studyMethod,
        scoringMap: [
            "개념을 완전히 이해한 후 문제풀이": ["systematic": 2],
            "문제를 풀면서 개념을 익혀나가기": ["practical": 2],
            "요약 정리를 먼저 만들고 암기": ["goalOriented": 1, "systematic": 1],
            "실제 사례나 응용 위주로 학습": ["practical": 1, "creative": 2]
        ]
    ),
    
    // 목표 성향
    Question(id: 3, text: "공부하는 주된 이유는", options: [
        "구체적인 시험이나 자격증 합격": ["goalOriented": 2],
        "
    ], category: <#T##QuestionCategory#>)
]
