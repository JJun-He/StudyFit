//
//  SampleData.swift
//  StudyFit
//


import Foundation

struct SampleData {
    
    // MARK: - 인강 더미 데이터
    static let courses: [Course] = [
        
        // ============ 국어 인강 ============
        
        // 시험형 성향에 적합한 국어 강의들
        Course(
            id: "korean_exam_1",
            title: "수능 국어 기출문제 완벽분석",
            instructor: "이해황",
            platform: .megastudy,
            subject: .korean,
            price: 180000,
            originalPrice: 220000,
            rating: 4.8,
            reviewCount: 1240,
            duration: "40시간",
            difficulty: .intermediate,
            description: "10년간 수능 기출문제를 완벽 분석하여 출제 패턴을 익히고 실전 감각을 기르는 강의입니다. 문학, 비문학, 화법과 작문, 언어와 매체 영역별 핵심 해결법을 제시합니다.",
            thumbnailURL: "https://example.com/korean1.jpg",
            videoURL: "https://example.com/preview1.mp4",
            suitableFor: [.examFocused, .problemSolver],
            tags: ["기출문제", "실전", "수능완성", "패턴분석"],
            isPopular: true,
            createdAt: Date().addingTimeInterval(-86400 * 30)
        ),
        
        Course(
            id: "korean_concept_1",
            title: "국어 개념의 모든 것 - 문법부터 문학까지",
            instructor: "신영균",
            platform: .etoos,
            subject: .korean,
            price: 150000,
            originalPrice: nil,
            rating: 4.9,
            reviewCount: 892,
            duration: "60시간",
            difficulty: .beginner,
            description: "국어의 기초 개념부터 심화 내용까지 체계적으로 학습합니다. 문법 원리, 문학 갈래별 특징, 독서 방법론을 단계별로 완성하는 강의입니다.",
            thumbnailURL: "https://example.com/korean2.jpg",
            videoURL: nil,
            suitableFor: [.conceptMaster, .steady],
            tags: ["개념완성", "체계적", "기초부터", "단계별"],
            isPopular: false,
            createdAt: Date().addingTimeInterval(-86400 * 45)
        ),
        
        // ============ 수학 인강 ============
        
        Course(
            id: "math_problem_1",
            title: "수학I 킬러문제 정복하기",
            instructor: "현우진",
            platform: .megastudy,
            subject: .math,
            price: 200000,
            originalPrice: 250000,
            rating: 4.7,
            reviewCount: 2180,
            duration: "35시간",
            difficulty: .advanced,
            description: "수능 수학I 4점짜리 고난도 문제를 집중적으로 다룹니다. 지수로그함수, 삼각함수, 수열 영역의 킬러문제 해결 전략을 체계적으로 학습합니다.",
            thumbnailURL: "https://example.com/math1.jpg",
            videoURL: "https://example.com/preview2.mp4",
            suitableFor: [.problemSolver, .intensive],
            tags: ["문제풀이", "고난도", "킬러문제", "실전연습"],
            isPopular: true,
            createdAt: Date().addingTimeInterval(-86400 * 20)
        ),
        
        Course(
            id: "math_concept_1",
            title: "수학의 정석 - 개념부터 응용까지",
            instructor: "정승제",
            platform: .daesung,
            subject: .math,
            price: 170000,
            originalPrice: 200000,
            rating: 4.6,
            reviewCount: 1560,
            duration: "80시간",
            difficulty: .intermediate,
            description: "수학I의 모든 개념을 처음부터 끝까지 완벽하게 이해할 수 있도록 구성된 강의입니다. 공식의 유도과정과 원리를 중심으로 설명합니다.",
            thumbnailURL: "https://example.com/math2.jpg",
            videoURL: nil,
            suitableFor: [.conceptMaster, .steady],
            tags: ["개념완성", "원리이해", "체계적", "기초탄탄"],
            isPopular: false,
            createdAt: Date().addingTimeInterval(-86400 * 60)
        ),
        
        Course(
            id: "math_intensive_1",
            title: "수학 단기완성 집중특강",
            instructor: "김기현",
            platform: .etoos,
            subject: .math,
            price: 120000,
            originalPrice: nil,
            rating: 4.5,
            reviewCount: 780,
            duration: "20시간",
            difficulty: .intermediate,
            description: "짧은 시간에 수학 핵심 개념과 문제유형을 모두 익힐 수 있는 집중 강의입니다. 시험 직전 최종 정리에 최적화되어 있습니다.",
            thumbnailURL: "https://example.com/math3.jpg",
            videoURL: "https://example.com/preview3.mp4",
            suitableFor: [.intensive, .examFocused],
            tags: ["단기완성", "집중", "핵심정리", "시험대비"],
            isPopular: true,
            createdAt: Date().addingTimeInterval(-86400 * 10)
        ),
        
        // ============ 영어 인강 ============
        
        Course(
            id: "english_grammar_1",
            title: "영어 문법 완성 - 구문독해의 기초",
            instructor: "조정식",
            platform: .megastudy,
            subject: .english,
            price: 160000,
            originalPrice: 190000,
            rating: 4.8,
            reviewCount: 1920,
            duration: "45시간",
            difficulty: .beginner,
            description: "영어 문법의 모든 것을 체계적으로 학습하여 독해의 기초를 다집니다. 문장구조 분석 능력을 기를 수 있는 강의입니다.",
            thumbnailURL: "https://example.com/english1.jpg",
            videoURL: nil,
            suitableFor: [.conceptMaster, .steady],
            tags: ["문법완성", "체계적", "구문분석", "기초다지기"],
            isPopular: false,
            createdAt: Date().addingTimeInterval(-86400 * 40)
        ),
        
        Course(
            id: "english_reading_1",
            title: "EBS 연계 독해 실전 완성",
            instructor: "이명학",
            platform: .ebsi,
            subject: .english,
            price: 0,
            originalPrice: nil,
            rating: 4.7,
            reviewCount: 3250,
            duration: "30시간",
            difficulty: .intermediate,
            description: "EBS 수능완성과 수능특강 지문을 중심으로 실전 독해력을 기릅니다. 빈출 어휘와 구문을 함께 학습할 수 있습니다.",
            thumbnailURL: "https://example.com/english2.jpg",
            videoURL: "https://example.com/preview4.mp4",
            suitableFor: [.examFocused, .problemSolver],
            tags: ["EBS연계", "실전", "독해완성", "수능대비"],
            isPopular: true,
            createdAt: Date().addingTimeInterval(-86400 * 15)
        ),
        
        // ============ 과학 인강 ============
        
        Course(
            id: "physics_concept_1",
            title: "물리학I 개념완성 - 역학부터 전기까지",
            instructor: "배기범",
            platform: .etoos,
            subject: .science,
            price: 180000,
            originalPrice: 220000,
            rating: 4.9,
            reviewCount: 1450,
            duration: "50시간",
            difficulty: .intermediate,
            description: "물리학I의 모든 개념을 원리부터 차근차근 설명합니다. 공식 암기가 아닌 물리 현상의 이해를 통해 문제 해결 능력을 기릅니다.",
            thumbnailURL: "https://example.com/physics1.jpg",
            videoURL: nil,
            suitableFor: [.conceptMaster, .steady],
            tags: ["개념완성", "원리이해", "체계적", "물리현상"],
            isPopular: false,
            createdAt: Date().addingTimeInterval(-86400 * 55)
        ),
        
        Course(
            id: "chemistry_problem_1",
            title: "화학I 실전문제 마스터",
            instructor: "박상현",
            platform: .daesung,
            subject: .science,
            price: 190000,
            originalPrice: nil,
            rating: 4.6,
            reviewCount: 1120,
            duration: "40시간",
            difficulty: .advanced,
            description: "화학I 고난도 문제를 유형별로 분석하고 해결 전략을 제시합니다. 계산 문제와 개념 문제를 균형있게 다룹니다.",
            thumbnailURL: "https://example.com/chemistry1.jpg",
            videoURL: "https://example.com/preview5.mp4",
            suitableFor: [.problemSolver, .intensive],
            tags: ["문제풀이", "유형분석", "고난도", "실전연습"],
            isPopular: true,
            createdAt: Date().addingTimeInterval(-86400 * 25)
        ),
        
        // ============ 사회 인강 ============
        
        Course(
            id: "history_exam_1",
            title: "한국사 기출문제 총정리",
            instructor: "최태성",
            platform: .ebsi,
            subject: .history,
            price: 0,
            originalPrice: nil,
            rating: 4.8,
            reviewCount: 4890,
            duration: "25시간",
            difficulty: .intermediate,
            description: "한국사 기출문제를 시대순으로 정리하고 출제 포인트를 분석합니다. 스토리텔링을 통한 암기법도 함께 제공합니다.",
            thumbnailURL: "https://example.com/history1.jpg",
            videoURL: nil,
            suitableFor: [.examFocused, .steady],
            tags: ["기출문제", "시대순", "스토리텔링", "암기법"],
            isPopular: true,
            createdAt: Date().addingTimeInterval(-86400 * 35)
        ),
        
        // ============ 종합/전과목 인강 ============
        
        Course(
            id: "all_intensive_1",
            title: "수능 전과목 파이널 특강",
            instructor: "김범준",
            platform: .megastudy,
            subject: .all,
            price: 350000,
            originalPrice: 450000,
            rating: 4.7,
            reviewCount: 2340,
            duration: "60시간",
            difficulty: .advanced,
            description: "수능 직전 모든 과목의 핵심 내용을 압축하여 정리하는 강의입니다. 과목별 최종 체크포인트와 실전 팁을 제공합니다.",
            thumbnailURL: "https://example.com/all1.jpg",
            videoURL: "https://example.com/preview6.mp4",
            suitableFor: [.intensive, .examFocused],
            tags: ["파이널", "전과목", "핵심정리", "실전팁"],
            isPopular: true,
            createdAt: Date().addingTimeInterval(-86400 * 5)
        )
    ]
    
    // MARK: - 학원 더미 데이터
    static let academies: [Academy] = [
        
        // ============ 강남 지역 학원 ============
        
        Academy(
            id: "academy_gangnam_1",
            name: "강남 메가스터디 학원",
            address: "서울 강남구 역삼동 123-45",
            phoneNumber: "02-1234-5678",
            latitude: 37.4979,
            longitude: 127.0276,
            rating: 4.6,
            reviewCount: 890,
            subjects: [.math, .english, .science],
            specialties: ["수능 전문", "소수정예", "개별관리"],
            priceRange: "월 30-50만원",
            description: "강남 지역 최고의 입시 전문 학원입니다. 소수정예 시스템으로 학생 한 명 한 명을 세심하게 관리하며, 매년 높은 명문대 합격률을 자랑합니다.",
            imageURLs: ["https://example.com/academy1_1.jpg", "https://example.com/academy1_2.jpg"],
            workingHours: "월-토 09:00-22:00",
            suitableFor: [.examFocused, .intensive],
            features: ["소수정예", "개별상담", "모의고사", "자율학습실"],
            distance: 2.3
        ),
        
        Academy(
            id: "academy_gangnam_2",
            name: "개념완성 수학학원",
            address: "서울 강남구 청담동 67-89",
            phoneNumber: "02-2345-6789",
            latitude: 37.5172,
            longitude: 127.0473,
            rating: 4.8,
            reviewCount: 340,
            subjects: [.math],
            specialties: ["수학 전문", "개념 중심", "체계적 커리큘럼"],
            priceRange: "월 25-40만원",
            description: "수학 개념을 완벽하게 이해시키는 것을 목표로 하는 전문 학원입니다. 공식 암기가 아닌 원리 이해를 통해 응용력을 기릅니다.",
            imageURLs: ["https://example.com/academy2_1.jpg"],
            workingHours: "월-금 15:00-22:00, 토 10:00-18:00",
            suitableFor: [.conceptMaster, .steady],
            features: ["개념 중심", "체계적", "단계별 학습", "충분한 설명"],
            distance: 1.8
        ),
        
        Academy(
            id: "academy_gangnam_3",
            name: "문제풀이 전문 학원",
            address: "서울 강남구 논현동 234-56",
            phoneNumber: "02-3456-7890",
            latitude: 37.5111,
            longitude: 127.0389,
            rating: 4.5,
            reviewCount: 560,
            subjects: [.math, .english, .science],
            specialties: ["문제풀이 중심", "실전 감각", "시간 관리"],
            priceRange: "월 28-45만원",
            description: "다양한 유형의 문제를 통해 실전 감각을 기르는 학원입니다. 제한시간 내 문제 해결 능력 향상에 특화되어 있습니다.",
            imageURLs: ["https://example.com/academy3_1.jpg", "https://example.com/academy3_2.jpg"],
            workingHours: "월-토 08:00-23:00",
            suitableFor: [.problemSolver, .intensive],
            features: ["문제풀이", "시간관리", "실전연습", "다양한 유형"],
            distance: 3.1
        ),
        
        // ============ 서초 지역 학원 ============
        
        Academy(
            id: "academy_seocho_1",
            name: "서초 꾸준학습 학원",
            address: "서울 서초구 서초동 345-67",
            phoneNumber: "02-4567-8901",
            latitude: 37.4837,
            longitude: 127.0324,
            rating: 4.7,
            reviewCount: 720,
            subjects: [.korean, .english, .socialStudies],
            specialties: ["장기 계획", "규칙적 학습", "습관 형성"],
            priceRange: "월 20-35만원",
            description: "학생들의 꾸준한 학습 습관 형성에 중점을 두는 학원입니다. 장기적인 관점에서 체계적인 학습 계획을 세우고 실행합니다.",
            imageURLs: ["https://example.com/academy4_1.jpg"],
            workingHours: "월-금 16:00-21:00, 토 13:00-18:00",
            suitableFor: [.steady, .conceptMaster],
            features: ["장기계획", "습관형성", "체계적", "꾸준함"],
            distance: 4.2
        ),
        
        Academy(
            id: "academy_seocho_2",
            name: "집중학습 부트캠프",
            address: "서울 서초구 반포동 456-78",
            phoneNumber: "02-5678-9012",
            latitude: 37.5014,
            longitude: 127.0071,
            rating: 4.4,
            reviewCount: 280,
            subjects: [.math, .science],
            specialties: ["집중 학습", "단기 완성", "몰입 환경"],
            priceRange: "월 40-60만원",
            description: "짧은 시간에 최대 효과를 낼 수 있도록 고안된 집중 학습 프로그램입니다. 완전한 몰입 환경을 제공합니다.",
            imageURLs: ["https://example.com/academy5_1.jpg", "https://example.com/academy5_2.jpg"],
            workingHours: "월-토 09:00-24:00",
            suitableFor: [.intensive, .examFocused],
            features: ["집중학습", "몰입환경", "단기완성", "최대효율"],
            distance: 5.7
        ),
        
        // ============ 노원구 지역 학원 ============
        
        Academy(
            id: "academy_nowon_1",
            name: "노원 종합학원",
            address: "서울 노원구 상계동 789-01",
            phoneNumber: "02-6789-0123",
            latitude: 37.6541,
            longitude: 127.0651,
            rating: 4.3,
            reviewCount: 450,
            subjects: [.korean, .math, .english, .science],
            specialties: ["전과목 관리", "내신 전문", "학교별 맞춤"],
            priceRange: "월 25-40만원",
            description: "지역 학교들의 내신 시험을 철저히 분석하여 맞춤형 교육을 제공하는 종합 학원입니다.",
            imageURLs: ["https://example.com/academy6_1.jpg"],
            workingHours: "월-토 14:00-22:00",
            suitableFor: [.steady, .examFocused],
            features: ["전과목", "내신전문", "학교별맞춤", "체계적관리"],
            distance: 8.9
        ),
        
        // ============ 분당 지역 학원 ============
        
        Academy(
            id: "academy_bundang_1",
            name: "분당 개념수학 학원",
            address: "경기 성남시 분당구 정자동 567-89",
            phoneNumber: "031-1234-5678",
            latitude: 37.3595,
            longitude: 127.1052,
            rating: 4.9,
            reviewCount: 190,
            subjects: [.math],
            specialties: ["개념 이해", "단계별 학습", "개별 진도"],
            priceRange: "월 30-45만원",
            description: "수학 개념을 확실히 이해시키는 데 특화된 소규모 학원입니다. 학생별 개별 진도로 맞춤 교육을 실시합니다.",
            imageURLs: ["https://example.com/academy7_1.jpg", "https://example.com/academy7_2.jpg"],
            workingHours: "월-금 15:00-21:00",
            suitableFor: [.conceptMaster, .steady],
            features: ["개념중심", "소규모", "개별진도", "맞춤교육"],
            distance: 12.3
        )
    ]
}
