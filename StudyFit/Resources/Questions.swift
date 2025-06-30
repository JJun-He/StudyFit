//
//  Questions.swift
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

// MARK - Sample Questions Data
extension Question{
    static let samepleQuestions: [Question] = {
        // 문항 1-3: 학습 시간 & 패턴
        Question(
            id: 1,
            text: "평소 공부할 때 가장 집중이 잘 되는 시간은?",
            options: [
                "등교 전 새벽 (6~8시)",
                "수업 후 오후 (4-7시)",
                "저녁 식사 후 (8-10시)",
                "밤늦게 (10시-12시)",
                "시간은 상관없고 컨디션 따라",
            ],
            category: .studyTime,
            scoringMap: [
                "등교 전 새벽 (6-8시)": ["steady": 2, "examFocused": 1],
                "수업 후 오후 (4-7시)": ["steady": 1, "conceptMaster": 1],
                "저녁 식사 후 (8-10시)": ["examFocused": 1, "problemSolver": 1],
                "밤늦게 (10시-12시)": ["intensive": 2],
                "시간은 상관없고 컨디션 따라": ["intensive": 1]
            ]
        ),
        
        // 문항 2
        Question(
            id: 2,
            text: "시험 기간 공부 스타일은?",
            options: [
            "시험 2~3주 전부터 꾸준히 준비",
            "시험 1주 전부터 집중적으로",
            "시험 2~3일 전 벼락치기",
            "평소에 미리미리 준비해둠",
            "그때그때 상황에 맞춰서"
            ],
            category: .studyPattern,
            scoringMap: [
                "시험 2-3주 전부터 꾸준히 준비": ["steady":2, "examFocused": 1],
                "시험 1주 전부터 집중적으로": ["examFocused": 2],
                "시험 2-3일 전 벼락치기": ["intensive": 2],
                "평소에 미리미리 준비해둠": ["steady":2, "coneptMaster": 1],
                "그때그때 상황에 맞춰서": ["intensive": 1]
            ]
        ),
        
        // 문항 3
        Question(
            id: 3,
            text: "하루 공부 시간을 어떻게 나누는 편인가요?",
            options: [
                "한 과목씩 긴 시간 몰아서",
                "여러 과목을 짧게짧게 번갈아",
                "어려운 과목부터 먼저",
                "쉬운 과목부터 차근차근",
                "그날 기분에 따라"
            ],
            category: .studyPattern,
            scoringMap: [
                "한 과목씩 긴 시간 몰아서": ["intensive": 2, "conceptMaster": 1],
                "여러 과목을 짧게짧게 번갈아": ["problemSolver": 1, "examFocused": 1],
                "어려운 과목부터 먼저": ["intensive": 1, "problemSolver": 1],
                "쉬운 과목부터 차근차근": ["steady": 2],
                "그날 기분에 따라": ["intensive": 1]
            ]
        ),
        
        // 문항 4
        Question(
            id: 4,
            text: "새로운 단원을 공부할 때 어떻게 시작하나요?",
            options: [
                "교과서나 개념서부터 정독",
                "문제집 예제 문제부터 풀어보기",
                "인강이나 수업 먼저 듣기",
                "요약 정리부터 만들기",
                "기출문제 먼저 확인하기"
            ],
            category: .studyMethod,
            scoringMap: [
                "교과서나 개념서부터 정독": ["conceptMaster": 2],
                "문제집 예제 문제부터 풀어보기": ["problemSolver": 2],
                "인강이나 수업 먼저 듣기": ["steady": 1, "conceptMaster": 1],
                "요약 정리부터 만들기": ["examFocused": 1, "conceptMaster": 1],
                "기출문제 먼저 확인하기": ["examFocused": 2]
            ]
        ),

        // 문항 5
        Question(
            id: 5,
            text: "문제를 틀렸을 때 보통 어떻게 하나요?",
            options: [
                "해설을 보고 이해될 때까지 분석",
                "비슷한 유형 문제를 더 찾아서 풀기",
                "개념책으로 돌아가서 다시 공부",
                "선생님이나 친구에게 질문하기",
                "일단 넘어가고 나중에 다시 보기"
            ],
            category: .problemSolving,
            scoringMap: [
                "해설을 보고 이해될 때까지 분석": ["conceptMaster": 2],
                "비슷한 유형 문제를 더 찾아서 풀기": ["problemSolver": 2],
                "개념책으로 돌아가서 다시 공부": ["conceptMaster": 1, "steady": 1],
                "선생님이나 친구에게 질문하기": ["steady": 1],
                "일단 넘어가고 나중에 다시 보기": ["intensive": 1]
            ]
        ),

        // 문항 6
        Question(
            id: 6,
            text: "암기가 필요한 과목(영단어, 한국사 등)은 어떻게 공부하나요?",
            options: [
                "매일 조금씩 꾸준히 반복",
                "한번에 많이 외우고 테스트",
                "이해 위주로 스토리텔링해서 암기",
                "문제 풀면서 자연스럽게 암기",
                "시험 직전에 몰아서 암기"
            ],
            category: .memorization,
            scoringMap: [
                "매일 조금씩 꾸준히 반복": ["steady": 2],
                "한번에 많이 외우고 테스트": ["intensive": 2],
                "이해 위주로 스토리텔링해서 암기": ["conceptMaster": 2],
                "문제 풀면서 자연스럽게 암기": ["problemSolver": 2],
                "시험 직전에 몰아서 암기": ["intensive": 1, "examFocused": 1]
            ]
        ),

        // 문항 7
        Question(
            id: 7,
            text: "수학 문제를 풀 때 선호하는 방식은?",
            options: [
                "공식을 완전히 이해하고 적용",
                "유형별 풀이법을 암기해서 적용",
                "많은 문제를 풀어서 감각으로",
                "어려운 문제부터 도전해보기",
                "쉬운 문제부터 차근차근"
            ],
            category: .problemSolving,
            scoringMap: [
                "공식을 완전히 이해하고 적용": ["conceptMaster": 2],
                "유형별 풀이법을 암기해서 적용": ["examFocused": 2],
                "많은 문제를 풀어서 감각으로": ["problemSolver": 2],
                "어려운 문제부터 도전해보기": ["intensive": 1, "problemSolver": 1],
                "쉬운 문제부터 차근차근": ["steady": 2]
            ]
        ),
        
        // 문항 8
        Question(
            id: 8,
            text: "공부하는 가장 큰 목표는?",
            options: [
                "원하는 대학 합격",
                "내신 등급 올리기",
                "특정 과목 실력 늘리기",
                "전체적인 성적 향상",
                "공부 습관 만들기"
            ],
            category: .motivation,
            scoringMap: [
                "원하는 대학 합격": ["examFocused": 2],
                "내신 등급 올리기": ["examFocused": 1, "steady": 1],
                "특정 과목 실력 늘리기": ["conceptMaster": 2],
                "전체적인 성적 향상": ["steady": 2],
                "공부 습관 만들기": ["steady": 2]
            ]
        ),

        // 문항 9
        Question(
            id: 9,
            text: "성적이 잘 나왔을 때 그 이유는 보통?",
            options: [
                "평소에 꾸준히 공부해서",
                "시험 전 집중적으로 준비해서",
                "문제 유형을 정확히 파악해서",
                "개념을 확실히 이해해서",
                "운이 좋아서"
            ],
            category: .selfAnalysis,
            scoringMap: [
                "평소에 꾸준히 공부해서": ["steady": 2],
                "시험 전 집중적으로 준비해서": ["intensive": 2],
                "문제 유형을 정확히 파악해서": ["examFocused": 2],
                "개념을 확실히 이해해서": ["conceptMaster": 2],
                "운이 좋아서": ["intensive": 1]
            ]
        ),

        // 문항 10
        Question(
            id: 10,
            text: "공부할 때 가장 중요하게 생각하는 것은?",
            options: [
                "정확한 개념 이해",
                "많은 문제 풀이 경험",
                "효율적인 시간 활용",
                "꾸준한 학습 습관",
                "시험에서 점수 잘 받기"
            ],
            category: .priority,
            scoringMap: [
                "정확한 개념 이해": ["conceptMaster": 2],
                "많은 문제 풀이 경험": ["problemSolver": 2],
                "효율적인 시간 활용": ["intensive": 2],
                "꾸준한 학습 습관": ["steady": 2],
                "시험에서 점수 잘 받기": ["examFocused": 2]
            ]
        ),
        
        // 문항 11
        Question(
            id: 11,
            text: "공부하기 좋은 장소는?",
            options: [
                "집 책상에서 혼자",
                "도서관이나 독서실",
                "카페나 스터디카페",
                "친구들과 함께 스터디",
                "어디든 상관없음"
            ],
            category: .environment,
            scoringMap: [
                "집 책상에서 혼자": ["steady": 1, "conceptMaster": 1],
                "도서관이나 독서실": ["examFocused": 1, "steady": 1],
                "카페나 스터디카페": ["intensive": 1],
                "친구들과 함께 스터디": ["problemSolver": 1],
                "어디든 상관없음": ["intensive": 1]
            ]
        ),

        // 문항 12
        Question(
            id: 12,
            text: "공부하면서 음악을 듣는 편인가요?",
            options: [
                "절대 안 듣고 완전 조용히",
                "잔잔한 배경음악 정도",
                "좋아하는 음악 들으면서",
                "백색소음이나 자연음",
                "그때그때 다름"
            ],
            category: .environment,
            scoringMap: [
                "절대 안 듣고 완전 조용히": ["conceptMaster": 1, "examFocused": 1],
                "잔잔한 배경음악 정도": ["steady": 1],
                "좋아하는 음악 들으면서": ["intensive": 1],
                "백색소음이나 자연음": ["steady": 1, "conceptMaster": 1],
                "그때그때 다름": ["intensive": 1]
            ]
        ),

        // 문항 13
        Question(
            id: 13,
            text: "공부 중에 모르는 것이 생기면?",
            options: [
                "바로 찾아보거나 질문하기",
                "일단 표시해두고 나중에 해결",
                "스스로 고민해서 해결하려고 함",
                "인강이나 해설 찾아보기",
                "친구한테 물어보기"
            ],
            category: .problemSolving,
            scoringMap: [
                "바로 찾아보거나 질문하기": ["intensive": 1, "conceptMaster": 1],
                "일단 표시해두고 나중에 해결": ["steady": 1, "examFocused": 1],
                "스스로 고민해서 해결하려고 함": ["conceptMaster": 2],
                "인강이나 해설 찾아보기": ["problemSolver": 1, "examFocused": 1],
                "친구한테 물어보기": ["problemSolver": 1]
            ]
        ),
        
        // 문항 14
        Question(
            id: 14,
            text: "시험 스트레스를 받을 때 어떻게 해결하나요?",
            options: [
                "더 열심히 공부해서 불안감 해소",
                "운동이나 취미로 스트레스 해소",
                "친구들과 이야기하면서 해소",
                "충분한 휴식으로 컨디션 회복",
                "그냥 참고 견딤"
            ],
            category: .stressManagement,
            scoringMap: [
                "더 열심히 공부해서 불안감 해소": ["intensive": 2],
                "운동이나 취미로 스트레스 해소": ["steady": 1],
                "친구들과 이야기하면서 해소": ["problemSolver": 1],
                "충분한 휴식으로 컨디션 회복": ["steady": 2],
                "그냥 참고 견딤": ["examFocused": 1]
            ]
        ),

        // 문항 15
        Question(
            id: 15,
            text: "공부 계획을 세울 때 어떤 스타일인가요?",
            options: [
                "상세하게 시간표까지 짜서",
                "큰 틀만 정하고 유연하게",
                "단기 목표 위주로 계획",
                "장기 목표부터 역산해서 계획",
                "특별한 계획 없이 그때그때"
            ],
            category: .planning,
            scoringMap: [
                "상세하게 시간표까지 짜서": ["steady": 2, "examFocused": 1],
                "큰 틀만 정하고 유연하게": ["conceptMaster": 1, "intensive": 1],
                "단기 목표 위주로 계획": ["intensive": 2],
                "장기 목표부터 역산해서 계획": ["examFocused": 2, "steady": 1],
                "특별한 계획 없이 그때그때": ["intensive": 1]
            ]
        )

    }
}
